using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Appoynt.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPatientProfileAndFamilyMembers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateOnly>(
                name: "BirthDate",
                table: "Patients",
                type: "date",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "BloodGroup",
                table: "Patients",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "FamilyNumber",
                table: "Patients",
                type: "nvarchar(7)",
                maxLength: 7,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "HeightCm",
                table: "Patients",
                type: "decimal(5,1)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NationalId",
                table: "Patients",
                type: "nvarchar(14)",
                maxLength: 14,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PID",
                table: "Patients",
                type: "nvarchar(9)",
                maxLength: 9,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ProfilePhotoPath",
                table: "Patients",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SmokingStatus",
                table: "Patients",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "WeightKg",
                table: "Patients",
                type: "decimal(5,1)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "FamilyMembers",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    PID = table.Column<string>(type: "nvarchar(9)", maxLength: 9, nullable: false),
                    FullName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Gender = table.Column<int>(type: "int", nullable: false),
                    Relationship = table.Column<int>(type: "int", nullable: false),
                    BirthDate = table.Column<DateOnly>(type: "date", nullable: false),
                    PatientId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedById = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FamilyMembers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FamilyMembers_AspNetUsers_CreatedById",
                        column: x => x.CreatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_FamilyMembers_AspNetUsers_DeletedById",
                        column: x => x.DeletedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_FamilyMembers_AspNetUsers_UpdatedById",
                        column: x => x.UpdatedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_FamilyMembers_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "UX_Patients_NationalId",
                table: "Patients",
                column: "NationalId",
                unique: true,
                filter: "[DeletedAt] IS NULL AND [NationalId] IS NOT NULL");

            migrationBuilder.Sql(@"
                WITH CTE AS (
                    SELECT Id, 
                           CAST(1000000 + ROW_NUMBER() OVER (ORDER BY Id) AS NVARCHAR(7)) AS GeneratedFamilyNumber
                    FROM Patients
                    WHERE PID = '' OR PID IS NULL
                )
                UPDATE Patients
                SET FamilyNumber = CTE.GeneratedFamilyNumber,
                    PID = CTE.GeneratedFamilyNumber + 'U0'
                FROM Patients p
                INNER JOIN CTE ON p.Id = CTE.Id;
            ");

            migrationBuilder.CreateIndex(
                name: "UX_Patients_PID",
                table: "Patients",
                column: "PID",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_FamilyMembers_CreatedById",
                table: "FamilyMembers",
                column: "CreatedById");

            migrationBuilder.CreateIndex(
                name: "IX_FamilyMembers_DeletedById",
                table: "FamilyMembers",
                column: "DeletedById");

            migrationBuilder.CreateIndex(
                name: "IX_FamilyMembers_PatientId",
                table: "FamilyMembers",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_FamilyMembers_UpdatedById",
                table: "FamilyMembers",
                column: "UpdatedById");

            migrationBuilder.CreateIndex(
                name: "UX_FamilyMembers_PID",
                table: "FamilyMembers",
                column: "PID",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FamilyMembers");

            migrationBuilder.DropIndex(
                name: "UX_Patients_NationalId",
                table: "Patients");

            migrationBuilder.DropIndex(
                name: "UX_Patients_PID",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "BirthDate",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "BloodGroup",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "FamilyNumber",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "HeightCm",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "NationalId",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "PID",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "ProfilePhotoPath",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "SmokingStatus",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "WeightKg",
                table: "Patients");
        }
    }
}
