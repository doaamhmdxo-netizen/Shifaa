CREATE TABLE PATIENT
(
    PatientID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Governorate NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Password_ NVARCHAR(255) NOT NULL,
    EmailAddress NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NULL,
    TwoFactorAuthentication BIT NOT NULL,
    IsActive BIT NOT NULL,
    BookingStatus NVARCHAR(30) NOT NULL,

    PRIMARY KEY (PatientID)
);


CREATE TABLE DOCTOR
(
    DoctorID INT NOT NULL,
    ConsultationFee DECIMAL(10,2) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    ProfessionalLicenseNumber NVARCHAR(50) NOT NULL,
    HospitalName NVARCHAR(100) NULL,
    FullClinicAddress NVARCHAR(250) NOT NULL,
    MedicalSpecialty NVARCHAR(100) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL,
    Password_ NVARCHAR(255) NOT NULL,
    ExperienceYears INT NOT NULL,
    ClinicName NVARCHAR(100) NOT NULL,
    ProfessionalBio NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL,

    PRIMARY KEY (DoctorID)
);


CREATE TABLE APPOINTMENT
(
    AppointmentID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitType NVARCHAR(50) NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME(7) NOT NULL,
    NotesForDoctor NVARCHAR(MAX) NULL,
    Location_ NVARCHAR(250) NULL,
    Status_ NVARCHAR(30) NOT NULL,
    ConsultationTotal DECIMAL(10,2) NOT NULL,
    MobileNumber NVARCHAR(20) NOT NULL,
    PrescriptionDetails NVARCHAR(MAX) NULL,
    PatientFile NVARCHAR(500) NULL,
    IsConfirmed BIT NOT NULL,
    IsCancelled BIT NOT NULL,

    PRIMARY KEY (AppointmentID),

    FOREIGN KEY (PatientID)
    REFERENCES PATIENT(PatientID),

    FOREIGN KEY (DoctorID)
    REFERENCES DOCTOR(DoctorID)
);

CREATE TABLE REVIEW
(
    ReviewID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    Rating INT NOT NULL,
    CreatedAt DATETIME2(7) NOT NULL,
    Comment NVARCHAR(MAX) NULL,

    PRIMARY KEY (ReviewID),

    FOREIGN KEY (DoctorID)
    REFERENCES DOCTOR(DoctorID),

    FOREIGN KEY (PatientID)
    REFERENCES PATIENT(PatientID),

    CHECK (Rating BETWEEN 1 AND 5)
);

CREATE TABLE PHARMACY
(
    PharmacyID INT NOT NULL,
    PharmacyName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(250) NOT NULL,
    WorkingHours NVARCHAR(100) NOT NULL,
    OperatingHours NVARCHAR(100) NOT NULL,
    Longitude DECIMAL(10,7) NOT NULL,
    Latitude DECIMAL(10,7) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Attribute NVARCHAR(100) NULL,
    IsActive BIT NOT NULL,

    PRIMARY KEY (PharmacyID)
);


CREATE TABLE MEDICALFILE
(
    MedicalFileID INT NOT NULL,
    PatientID INT NOT NULL,
    Weight DECIMAL(5,2) NULL,
    SystolicBloodPressure INT NULL,
    DiastolicBloodPressure INT NULL,
    OxygenSaturation DECIMAL(5,2) NULL,
    BodyTemperature DECIMAL(4,1) NULL,
    HeartRate INT NULL,
    Height DECIMAL(5,2) NULL,
    BloodType NVARCHAR(5) NULL,
    BloodGlucose DECIMAL(7,2) NULL,
    ChronicDiseases NVARCHAR(MAX) NULL,
    Allergies NVARCHAR(MAX) NULL,
    MeasurementDate DATE NULL,
    PreviousSurgeries NVARCHAR(MAX) NULL,
    MedicationsAndDosages NVARCHAR(MAX) NULL,
    EmergencyContactName NVARCHAR(100) NULL,
    Relationship NVARCHAR(50) NULL,
    EmergencyPhoneNumber NVARCHAR(20) NULL,
    InformationForDoctor NVARCHAR(MAX) NULL,

    PRIMARY KEY (MedicalFileID),

    FOREIGN KEY (PatientID)
    REFERENCES PATIENT(PatientID)
);


CREATE TABLE WORKINGHOURS
(
    WorkingHoursID INT NOT NULL,
    DoctorID INT NOT NULL,
    FromTime TIME(7) NOT NULL,
    ToTime TIME(7) NOT NULL,
    OptionalBreak NVARCHAR(100) NULL,

    PRIMARY KEY (WorkingHoursID),

    FOREIGN KEY (DoctorID)
    REFERENCES DOCTOR(DoctorID)
);

CREATE TABLE CONVERSATIONS
(
    MessageID INT NOT NULL,
    MessageContent NVARCHAR(500) NOT NULL,
    MessageTimestamp DATETIME2(7) NOT NULL,
    IsRead BIT NOT NULL,

    PRIMARY KEY (MessageID)
);

CREATE TABLE ADMIN
(
    AdminID INT NOT NULL,
    PlatformName NVARCHAR(100) NOT NULL,
    EmailAddress NVARCHAR(100) NOT NULL,
    MobileNumber NVARCHAR(20) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    InvitationLink NVARCHAR(500) NULL,
    InvitationTokenStatus NVARCHAR(50) NULL,
    Verification BIT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    DisplayedSupportEmail NVARCHAR(100) NULL,
    SuspensionDuration INT NULL,
    ReasonForAction NVARCHAR(MAX) NULL,
    ActionType NVARCHAR(50) NULL,

    PRIMARY KEY (AdminID)
);

CREATE TABLE PASSWORD_RESET_TOKEN
(
    ResetID INT NOT NULL,
    TokenHash NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME2(7) NOT NULL,
    ExpiresAt DATETIME2(7) NOT NULL,
    IsUsed BIT NOT NULL,
    DoctorID INT NULL,
    PatientID INT NULL,
    AdminID INT NULL,

    PRIMARY KEY (ResetID),

    FOREIGN KEY (DoctorID)
    REFERENCES DOCTOR(DoctorID),

    FOREIGN KEY (PatientID)
    REFERENCES PATIENT(PatientID),

    FOREIGN KEY (AdminID)
    REFERENCES ADMIN(AdminID),

    CHECK
    (
        (CASE WHEN DoctorID IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN PatientID IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN AdminID IS NOT NULL THEN 1 ELSE 0 END) = 1
    )
);

CREATE TABLE [HAS (Ph-Con)]
(
    MessageID INT NOT NULL,
    PatientID INT NOT NULL,

    PRIMARY KEY (MessageID, PatientID),

    FOREIGN KEY (MessageID)
    REFERENCES CONVERSATIONS(MessageID),

    FOREIGN KEY (PatientID)
    REFERENCES PATIENT(PatientID)
);

CREATE TABLE [HAS (Do-Con)]
(
    MessageID INT NOT NULL,
    DoctorID INT NOT NULL,

    PRIMARY KEY (MessageID, DoctorID),

    FOREIGN KEY (MessageID)
    REFERENCES CONVERSATIONS(MessageID),

    FOREIGN KEY (DoctorID)
    REFERENCES DOCTOR(DoctorID)
);