/**
 * File Name      : 20260823195122_AddIsVerifiedToDoctorPhoneNumber.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-23
 * Version        : v1.0.0
 * Dependencies   : EF Core
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : 2026-08-23
 * Description    : Migration for adding IsVerified to DoctorPhoneNumber.
 */

using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Appoynt.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddIsVerifiedToDoctorPhoneNumber : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsVerified",
                table: "DoctorPhoneNumbers",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsVerified",
                table: "DoctorPhoneNumbers");
        }
    }
}
