CREATE DATABASE hospitales;
USE hospitales;

CREATE TABLE Patient (
    patient_id INT,
    patient_name VARCHAR(20),
    age INT,
    city VARCHAR(30)
);

INSERT INTO Patient VALUES (101, 'Rahul', 20, 'Mangalore');
INSERT INTO Patient VALUES (105, 'Priya', 23, 'Bangalore');
INSERT INTO Patient VALUES (104, 'Kiran', 26, 'Mysuru');
INSERT INTO Patient VALUES (102, 'Sneha', 20, 'Agra');

SELECT * FROM Patient;


CREATE TABLE Doctor (
    doctor_id INT,
    doctor_name VARCHAR(20),
    specialization VARCHAR(30)
);

INSERT INTO Doctor VALUES (201, 'Ravi', 'Cardiology');
INSERT INTO Doctor VALUES (202, 'Meena', 'Neurology');
INSERT INTO Doctor VALUES (203, 'Kumar', 'Orthopedics');
INSERT INTO Doctor VALUES (204, 'Priya', 'Dermatology');

SELECT * FROM Doctor;

CREATE TABLE Appointment (
    appointment_id INT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20)
);

INSERT INTO Appointment VALUES (301, 101, 201, '2026-10-20', 'Scheduled');
INSERT INTO Appointment VALUES (302, 105, 202, '2026-10-21', 'Scheduled');
INSERT INTO Appointment VALUES (303, 104, 203, '2026-10-22', 'Completed');
INSERT INTO Appointment VALUES (304, 102, 201, '2026-10-23', 'Scheduled');

SELECT * FROM Appointment;

SELECT p.patient_name, d.doctor_name,
       d.specialization, a.appointment_date
FROM Patient AS p
INNER JOIN Appointment AS a
    ON p.patient_id = a.patient_id
INNER JOIN Doctor AS d
    ON a.doctor_id = d.doctor_id
WHERE a.status = 'Scheduled';

SELECT * FROM Patient;

SELECT p.patient_id, p.patient_name,
       p.age, p.city, a.appointment_date
FROM Patient p
LEFT JOIN Appointment a
ON p.patient_id = a.patient_id;

SELECT * FROM Doctor;

