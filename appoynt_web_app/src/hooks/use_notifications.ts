import { useState, useMemo, useEffect, useCallback, useRef } from "react";
import type { NotificationItem, NotificationCategory } from "@/types/notification";
import { mockNotifications } from "@/data/mockNotifications";
import { sanitizeSearchQuery } from "@/lib/validators";

const DEFAULT_PAGE_SIZE = 10;
const MOCK_LOADING_DELAY_MS = 600;
const DEBOUNCE_DELAY_MS = 250;
const UNDO_TOAST_TIMEOUT_MS = 5000;

export function useNotifications(pageSize: number = DEFAULT_PAGE_SIZE) {
  const [notificationsList, setNotificationsList] = useState<NotificationItem[]>([]);
  const [activeCategoryTab, setActiveCategoryTab] = useState<NotificationCategory>("all");
  const [rawSearchQuery, setRawSearchQuery] = useState<string>("");
  const [debouncedSearchQuery, setDebouncedSearchQuery] = useState<string>("");
  const [activeDetailNotification, setActiveDetailNotification] = useState<NotificationItem | null>(null);
  
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState<boolean>(false);
  const [isDataLoading, setIsDataLoading] = useState<boolean>(true);
  const [hasLoadingError] = useState<boolean>(false);
  const [isProcessingAction, setIsProcessingAction] = useState<boolean>(false);
  const [currentPageNumber, setCurrentPageNumber] = useState<number>(1);

  // Undo state management
  const [lastDeletedItem, setLastDeletedItem] = useState<{
    item: NotificationItem;
    originalIndex: number;
  } | null>(null);
  const undoTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  // Initial data loading simulation
  useEffect(() => {
    let isMounted = true;
    const timer = setTimeout(() => {
      if (isMounted) {
        setNotificationsList(mockNotifications);
        setIsDataLoading(false);
      }
    }, MOCK_LOADING_DELAY_MS);

    return () => {
      isMounted = false;
      clearTimeout(timer);
    };
  }, []);

  // 1. Search Input Debouncing & Sanitization
  useEffect(() => {
    const handler = setTimeout(() => {
      const sanitized = sanitizeSearchQuery(rawSearchQuery);
      setDebouncedSearchQuery(sanitized);
    }, DEBOUNCE_DELAY_MS);

    return () => clearTimeout(handler);
  }, [rawSearchQuery]);

  // Single memoized pass for category counts (DRY)
  const tabCountersMap = useMemo(() => {
    const counts = {
      all: notificationsList.length,
      unread: 0,
      appointments: 0,
      reviews: 0,
    };

    notificationsList.forEach((item) => {
      if (!item.isRead) counts.unread += 1;
      if (
        item.type === "appointment" ||
        item.type === "cancellation" ||
        item.type === "reschedule"
      ) {
        counts.appointments += 1;
      }
      if (item.type === "review") counts.reviews += 1;
    });

    return counts;
  }, [notificationsList]);

  // Business Logic: Category & Debounced Search Text filtering
  const filteredNotificationsList = useMemo(() => {
    const query = debouncedSearchQuery.trim().toLowerCase();

    return notificationsList.filter((item) => {
      let categoryMatch = true;
      if (activeCategoryTab === "unread") {
        categoryMatch = !item.isRead;
      } else if (activeCategoryTab === "appointments") {
        categoryMatch =
          item.type === "appointment" ||
          item.type === "cancellation" ||
          item.type === "reschedule";
      } else if (activeCategoryTab === "reviews") {
        categoryMatch = item.type === "review";
      }

      if (!categoryMatch) return false;
      if (!query) return true;

      const title = item.title ? item.title.toLowerCase() : "";
      const desc = item.description ? item.description.toLowerCase() : "";

      return title.includes(query) || desc.includes(query);
    });
  }, [notificationsList, activeCategoryTab, debouncedSearchQuery]);

  const totalPagesCount = useMemo(() => {
    return Math.ceil(filteredNotificationsList.length / pageSize) || 1;
  }, [filteredNotificationsList, pageSize]);

  // 2. Pagination Boundary Validation (Auto-adjust out-of-bounds page)
  useEffect(() => {
    if (currentPageNumber > totalPagesCount && totalPagesCount > 0) {
      setCurrentPageNumber(totalPagesCount);
    }
  }, [currentPageNumber, totalPagesCount]);

  // Paginated output
  const paginatedNotificationsList = useMemo(() => {
    const validPage = Math.min(Math.max(1, currentPageNumber), totalPagesCount);
    const startIndex = (validPage - 1) * pageSize;
    return filteredNotificationsList.slice(startIndex, startIndex + pageSize);
  }, [filteredNotificationsList, currentPageNumber, totalPagesCount, pageSize]);

  // Action Handlers with Double-Submit / Rate-Limiting Protection
  const handleMarkAsRead = useCallback((notificationId: string) => {
    setNotificationsList((prev) =>
      prev.map((item) => (item.id === notificationId ? { ...item, isRead: true } : item))
    );
  }, []);

  const handleMarkAllAsRead = useCallback(async () => {
    if (isProcessingAction) return;
    setIsProcessingAction(true);
    try {
      setNotificationsList((prev) => prev.map((item) => ({ ...item, isRead: true })));
    } finally {
      setIsProcessingAction(false);
    }
  }, [isProcessingAction]);

  // Single Item Delete with Undo Toast capability
  const handleDeleteNotification = useCallback((notificationId: string) => {
    setNotificationsList((prev) => {
      const index = prev.findIndex((item) => item.id === notificationId);
      if (index !== -1) {
        const itemToDelete = prev[index];
        setLastDeletedItem({ item: itemToDelete, originalIndex: index });

        // Reset undo timer if already running
        if (undoTimeoutRef.current) clearTimeout(undoTimeoutRef.current);
        undoTimeoutRef.current = setTimeout(() => {
          setLastDeletedItem(null);
        }, UNDO_TOAST_TIMEOUT_MS);
      }
      return prev.filter((item) => item.id !== notificationId);
    });

    setActiveDetailNotification((prev) => (prev?.id === notificationId ? null : prev));
  }, []);

  // Restore deleted item from Undo Stack
  const handleUndoDelete = useCallback(() => {
    if (!lastDeletedItem) return;
    const { item, originalIndex } = lastDeletedItem;

    setNotificationsList((prev) => {
      const newList = [...prev];
      newList.splice(originalIndex, 0, item);
      return newList;
    });

    setLastDeletedItem(null);
    if (undoTimeoutRef.current) clearTimeout(undoTimeoutRef.current);
  }, [lastDeletedItem]);

  const handleConfirmDeleteAll = useCallback(async () => {
    if (isProcessingAction) return;
    setIsProcessingAction(true);
    try {
      setNotificationsList([]);
      setIsDeleteDialogOpen(false);
      setActiveDetailNotification(null);
      setLastDeletedItem(null);
    } finally {
      setIsProcessingAction(false);
    }
  }, [isProcessingAction]);

  const handleSelectNotificationCard = useCallback(
    (item: NotificationItem) => {
      setActiveDetailNotification(item);
      if (!item.isRead) {
        handleMarkAsRead(item.id);
      }
    },
    [handleMarkAsRead]
  );

  const handleCategoryChange = useCallback((category: NotificationCategory) => {
    setActiveCategoryTab(category);
    setCurrentPageNumber(1);
  }, []);

  const handleSearchChange = useCallback((text: string) => {
    setRawSearchQuery(text);
    setCurrentPageNumber(1);
  }, []);

  const handleClearSearch = useCallback(() => {
    setRawSearchQuery("");
    setDebouncedSearchQuery("");
    setCurrentPageNumber(1);
  }, []);

  return {
    notificationsList,
    filteredNotificationsList,
    paginatedNotificationsList,
    tabCountersMap,
    totalUnreadCount: tabCountersMap.unread,
    activeCategoryTab,
    searchTextQuery: rawSearchQuery,
    debouncedSearchQuery,
    activeDetailNotification,
    isDeleteDialogOpen,
    isDataLoading,
    hasLoadingError,
    isProcessingAction,
    currentPageNumber,
    totalPagesCount,
    lastDeletedItem,
    hasSearchFilterActive: debouncedSearchQuery.trim().length > 0,
    // Methods
    handleMarkAsRead,
    handleMarkAllAsRead,
    handleDeleteNotification,
    handleUndoDelete,
    handleConfirmDeleteAll,
    handleSelectNotificationCard,
    handleCategoryChange,
    handleSearchChange,
    handleClearSearch,
    setCurrentPageNumber,
    setIsDeleteDialogOpen,
    setActiveDetailNotification,
    dismissUndoToast: () => setLastDeletedItem(null),
  };
}
