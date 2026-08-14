/**
 * File Name      : PidGenerator.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-10
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-10
 * Description    : Generates PIDs for patients and family members.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using Appoynt.Domain.Enums;
using Appoynt.Domain.Common.Constants;

namespace Appoynt.Infrastructure.Authentication.Patient;

/// <summary>
/// Static helper class for generating PIDs.
/// </summary>
public static class PidGenerator
{
    /// <summary>
    /// Generates a random 7-digit family number.
    /// </summary>
    public static string GenerateRandomFamilyNumber(Random random)
    {
        // Generate random number within limits
        int num = random.Next(PatientConstants.FamilyNumberMinValue, PatientConstants.FamilyNumberMaxValue + 1);
        
        // Return string representation
        return num.ToString();
    }

    /// <summary>
    /// Generates a full PID from components.
    /// </summary>
    public static string GeneratePid(string familyNumber, FamilyRelationship relationship, int sequenceNumber)
    {
        // Get the relationship code
        char code = GetRelationshipCode(relationship);
        
        // Combine into PID
        return $"{familyNumber}{code}{sequenceNumber}";
    }

    /// <summary>
    /// Finds the lowest available sequence number.
    /// </summary>
    public static int FindLowestAvailableSequence(IEnumerable<int> usedSequences)
    {
        // Iterate through all possible sequences
        for (int i = 0; i <= PatientConstants.MaxFamilyMemberSequence; i++)
        {
            // Check if it's used
            if (!usedSequences.Contains(i))
            {
                // Return first available
                return i;
            }
            else
            {
                // No action required.
            }
        }
        
        // If all are used, throw exception
        throw new InvalidOperationException("Sequence limit reached.");
    }

    /// <summary>
    /// Gets the character code for a relationship.
    /// </summary>
    public static char GetRelationshipCode(FamilyRelationship relationship)
    {
        // Switch on relationship
        switch (relationship)
        {
            case FamilyRelationship.User:
                // Return User code
                return 'U';
            case FamilyRelationship.Wife:
                // Return Wife code
                return 'W';
            case FamilyRelationship.Husband:
                // Return Husband code
                return 'H';
            case FamilyRelationship.Son:
                // Return Son code
                return 'S';
            case FamilyRelationship.Daughter:
                // Return Daughter code
                return 'D';
            case FamilyRelationship.Parent:
                // Return Parent code
                return 'P';
            default:
                // Return default character
                return 'X';
        }
    }

    /// <summary>
    /// Validates consistency between gender and relationship.
    /// </summary>
    public static bool ValidateGenderRelationshipConsistency(Gender gender, FamilyRelationship relationship)
    {
        // Check combinations
        if (relationship == FamilyRelationship.Wife)
        {
            // Wife must be female
            return gender == Gender.Female;
        }
        else if (relationship == FamilyRelationship.Husband)
        {
            // Husband must be male
            return gender == Gender.Male;
        }
        else if (relationship == FamilyRelationship.Son)
        {
            // Son must be male
            return gender == Gender.Male;
        }
        else if (relationship == FamilyRelationship.Daughter)
        {
            // Daughter must be female
            return gender == Gender.Female;
        }
        else
        {
            // Parents and User can be either
            return true;
        }
    }
}
