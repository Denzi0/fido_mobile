-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 03, 2021 at 04:22 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fido`
--

-- --------------------------------------------------------

--
-- Table structure for table `donation_box`
--

CREATE TABLE `donation_box` (
  `donation_boxID` int(11) NOT NULL,
  `requestID` int(255) NOT NULL,
  `donationID` int(255) NOT NULL,
  `date_given` varchar(255) NOT NULL,
  `orgFeedback` varchar(255) NOT NULL,
  `statusID` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `donation_box`
--
ALTER TABLE `donation_box`
  ADD PRIMARY KEY (`donation_boxID`),
  ADD KEY `donation_box_ibfk_1` (`donationID`),
  ADD KEY `donation_box_ibfk_2` (`requestID`),
  ADD KEY `statusID` (`statusID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `donation_box`
--
ALTER TABLE `donation_box`
  MODIFY `donation_boxID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `donation_box`
--
ALTER TABLE `donation_box`
  ADD CONSTRAINT `donation_box_ibfk_1` FOREIGN KEY (`donationID`) REFERENCES `donation` (`donationID`) ON DELETE CASCADE,
  ADD CONSTRAINT `donation_box_ibfk_2` FOREIGN KEY (`requestID`) REFERENCES `donation_request` (`requestID`) ON DELETE CASCADE,
  ADD CONSTRAINT `donation_box_ibfk_3` FOREIGN KEY (`statusID`) REFERENCES `status` (`statusID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
