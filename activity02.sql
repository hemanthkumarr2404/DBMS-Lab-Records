CREATE TABLE Book (
    Book_ID INT PRIMARY KEY,
    Book_Title VARCHAR(100),
    Available_Copies INT NOT NULL
);

CREATE TABLE Member (
    Member_ID INT PRIMARY KEY,
    Member_Name VARCHAR(100)
);

CREATE TABLE Book_Issue (
    Issue_ID INT AUTO_INCREMENT PRIMARY KEY,
    Member_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    Issue_Date DATE NOT NULL,
    Return_Date DATE NULL,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID)
);

DELIMITER //
CREATE PROCEDURE IssueBook(
    IN p_Member_ID INT,
    IN p_Book_ID INT
)
BEGIN
    DECLARE v_Member_Count INT DEFAULT 0;
    DECLARE v_Book_Count INT DEFAULT 0;
    DECLARE v_Available_Copies INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_Member_Count
    FROM Member
    WHERE Member_ID = p_Member_ID;

    IF v_Member_Count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Member does not exist';
    END IF;

    SELECT COUNT(*)
    INTO v_Book_Count
    FROM Book
    WHERE Book_ID = p_Book_ID;

    IF v_Book_Count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book does not exist';
    END IF;

    SELECT Available_Copies
    INTO v_Available_Copies
    FROM Book
    WHERE Book_ID = p_Book_ID
    FOR UPDATE;

    IF v_Available_Copies <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No copies available';
    END IF;

    INSERT INTO Book_Issue
        (Member_ID, Book_ID, Issue_Date, Return_Date)
    VALUES
        (p_Member_ID, p_Book_ID, CURDATE(), NULL);

    UPDATE Book
    SET Available_Copies = Available_Copies - 1
    WHERE Book_ID = p_Book_ID;

    COMMIT;
END//
CREATE PROCEDURE ReturnBook(
    IN p_Issue_ID INT
)
BEGIN
    DECLARE v_Book_ID INT DEFAULT NULL;
    DECLARE v_Return_Date DATE DEFAULT NULL;
    DECLARE v_Issue_Count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_Issue_Count
    FROM Book_Issue
    WHERE Issue_ID = p_Issue_ID;

    IF v_Issue_Count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Issue record does not exist';
    END IF;

    SELECT Book_ID, Return_Date
    INTO v_Book_ID, v_Return_Date
    FROM Book_Issue
    WHERE Issue_ID = p_Issue_ID
    FOR UPDATE;

    IF v_Return_Date IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book has already been returned';
    END IF;

    UPDATE Book_Issue
    SET Return_Date = CURDATE()
    WHERE Issue_ID = p_Issue_ID;

    UPDATE Book
    SET Available_Copies = Available_Copies + 1
    WHERE Book_ID = v_Book_ID;

    COMMIT;
END//

DELIMITER ;
INSERT INTO Book
VALUES
(1, 'Database Management Systems', 3),
(2, 'Computer Networks', 2);

INSERT INTO Member
VALUES
(101, 'Arun'),
(102, 'Priya');

CALL IssueBook(101, 1);
SELECT * FROM Book;
SELECT * FROM Book_Issue;
CALL ReturnBook(1);
SELECT * FROM Book;
SELECT * FROM Book_Issue;
CALL ReturnBook(1);