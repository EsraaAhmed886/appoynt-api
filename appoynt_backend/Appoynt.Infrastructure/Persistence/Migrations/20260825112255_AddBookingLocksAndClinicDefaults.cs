using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Appoynt.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddBookingLocksAndClinicDefaults : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsDefault",
                table: "Clinics",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<double>(
                name: "Latitude",
                table: "Clinics",
                type: "float",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "Longitude",
                table: "Clinics",
                type: "float",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "ExpiresAtUtc",
                table: "AppointmentSlots",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "HeldByUserId",
                table: "AppointmentSlots",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Clinics_DoctorId_IsDefault_Unique",
                table: "Clinics",
                columns: new[] { "DoctorId", "IsDefault" },
                unique: true,
                filter: "[IsDefault] = 1");

            migrationBuilder.CreateIndex(
                name: "IX_AppointmentSlots_HeldByUserId_Status",
                table: "AppointmentSlots",
                columns: new[] { "HeldByUserId", "Status" },
                filter: "[HeldByUserId] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_AppointmentSlots_AspNetUsers_HeldByUserId",
                table: "AppointmentSlots",
                column: "HeldByUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AppointmentSlots_AspNetUsers_HeldByUserId",
                table: "AppointmentSlots");

            migrationBuilder.DropIndex(
                name: "IX_Clinics_DoctorId_IsDefault_Unique",
                table: "Clinics");

            migrationBuilder.DropIndex(
                name: "IX_AppointmentSlots_HeldByUserId_Status",
                table: "AppointmentSlots");

            migrationBuilder.DropColumn(
                name: "IsDefault",
                table: "Clinics");

            migrationBuilder.DropColumn(
                name: "Latitude",
                table: "Clinics");

            migrationBuilder.DropColumn(
                name: "Longitude",
                table: "Clinics");

            migrationBuilder.DropColumn(
                name: "ExpiresAtUtc",
                table: "AppointmentSlots");

            migrationBuilder.DropColumn(
                name: "HeldByUserId",
                table: "AppointmentSlots");
        }
    }
}
