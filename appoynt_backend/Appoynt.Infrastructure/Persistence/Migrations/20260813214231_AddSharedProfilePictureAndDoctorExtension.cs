using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Appoynt.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddSharedProfilePictureAndDoctorExtension : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ProfilePicturePath",
                table: "AspNetUsers",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Bio",
                table: "Doctors",
                type: "nvarchar(2000)",
                maxLength: 2000,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Education",
                table: "Doctors",
                type: "nvarchar(1000)",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NameAr",
                table: "Doctors",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NameEn",
                table: "Doctors",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            // Data Migration: Copy existing patient profile photo paths to AspNetUsers.ProfilePicturePath before dropping the column.
            migrationBuilder.Sql(
                """
                UPDATE u
                SET u.ProfilePicturePath = p.ProfilePhotoPath
                FROM AspNetUsers u
                INNER JOIN Patients p ON p.UserId = u.Id
                WHERE p.ProfilePhotoPath IS NOT NULL AND p.DeletedAt IS NULL;
                """);

            migrationBuilder.DropColumn(
                name: "ProfilePhotoPath",
                table: "Patients");

            migrationBuilder.CreateTable(
                name: "DoctorPhoneNumbers",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DoctorId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Label = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DoctorPhoneNumbers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DoctorPhoneNumbers_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_DoctorPhoneNumbers_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_DoctorPhoneNumbers_AspNetUsers_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_DoctorPhoneNumbers_Doctors_DoctorId",
                        column: x => x.DoctorId,
                        principalTable: "Doctors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Specializations",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    NameEn = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    NameAr = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Specializations", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Specializations_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Specializations_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Specializations_AspNetUsers_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "DoctorSpecializations",
                columns: table => new
                {
                    DoctorId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    SpecializationId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DoctorSpecializations", x => new { x.DoctorId, x.SpecializationId });
                    table.ForeignKey(
                        name: "FK_DoctorSpecializations_Doctors_DoctorId",
                        column: x => x.DoctorId,
                        principalTable: "Doctors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_DoctorSpecializations_Specializations_SpecializationId",
                        column: x => x.SpecializationId,
                        principalTable: "Specializations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_DoctorPhoneNumbers_CreatedById",
                table: "DoctorPhoneNumbers",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_DoctorPhoneNumbers_DeletedById",
                table: "DoctorPhoneNumbers",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_DoctorPhoneNumbers_UpdatedById",
                table: "DoctorPhoneNumbers",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "UX_DoctorPhoneNumbers_DoctorId_PhoneNumber",
                table: "DoctorPhoneNumbers",
                columns: new[] { "DoctorId", "PhoneNumber" },
                unique: true,
                filter: "[DeletedAt] IS NULL");

            migrationBuilder.CreateIndex(
                name: "IX_DoctorSpecializations_SpecializationId",
                table: "DoctorSpecializations",
                column: "SpecializationId");

            migrationBuilder.CreateIndex(
                name: "IX_Specializations_CreatedById",
                table: "Specializations",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_Specializations_DeletedById",
                table: "Specializations",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_Specializations_UpdatedById",
                table: "Specializations",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "UX_Specializations_NameAr",
                table: "Specializations",
                column: "NameAr",
                unique: true,
                filter: "[DeletedAt] IS NULL");

            migrationBuilder.CreateIndex(
                name: "UX_Specializations_NameEn",
                table: "Specializations",
                column: "NameEn",
                unique: true,
                filter: "[DeletedAt] IS NULL");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DoctorPhoneNumbers");

            migrationBuilder.DropTable(
                name: "DoctorSpecializations");

            migrationBuilder.DropTable(
                name: "Specializations");

            migrationBuilder.DropColumn(
                name: "Bio",
                table: "Doctors");

            migrationBuilder.DropColumn(
                name: "Education",
                table: "Doctors");

            migrationBuilder.DropColumn(
                name: "NameAr",
                table: "Doctors");

            migrationBuilder.DropColumn(
                name: "NameEn",
                table: "Doctors");

            migrationBuilder.AddColumn<string>(
                name: "ProfilePhotoPath",
                table: "Patients",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.Sql(
                """
                UPDATE p
                SET p.ProfilePhotoPath = u.ProfilePicturePath
                FROM Patients p
                INNER JOIN AspNetUsers u ON u.Id = p.UserId
                WHERE u.ProfilePicturePath IS NOT NULL;
                """);

            migrationBuilder.DropColumn(
                name: "ProfilePicturePath",
                table: "AspNetUsers");
        }
    }
}
