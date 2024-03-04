-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 04 Mar 2024, 14:39
-- Wersja serwera: 10.4.24-MariaDB
-- Wersja PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `car_rental`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `active_reservations`
--

CREATE TABLE `active_reservations` (
  `id` bigint(11) NOT NULL,
  `car_id` bigint(11) NOT NULL,
  `account_id` bigint(11) NOT NULL,
  `date_of_rent_start` datetime NOT NULL,
  `date_of_expected_return` datetime NOT NULL,
  `status` varchar(8) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `active_reservations`
--

INSERT INTO `active_reservations` (`id`, `car_id`, `account_id`, `date_of_rent_start`, `date_of_expected_return`, `status`) VALUES
(65, 5, 45, '2024-03-04 10:00:00', '2024-03-05 10:00:00', 'active');

--
-- Wyzwalacze `active_reservations`
--
DELIMITER $$
CREATE TRIGGER `test3` BEFORE DELETE ON `active_reservations` FOR EACH ROW INSERT INTO `archival_reservations` (car_id, account_id, date_of_rent, date_of_return) VALUES (old.car_id, old.account_id, old.date_of_rent_start, old.date_of_expected_return)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `archival_reservations`
--

CREATE TABLE `archival_reservations` (
  `id` bigint(11) NOT NULL,
  `car_id` bigint(11) NOT NULL,
  `account_id` bigint(11) NOT NULL,
  `date_of_rent` datetime NOT NULL,
  `date_of_return` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `awaiting_reservations`
--

CREATE TABLE `awaiting_reservations` (
  `id` bigint(11) NOT NULL,
  `car_id` bigint(11) NOT NULL,
  `account_id` bigint(11) NOT NULL,
  `date_of_rent_start` datetime NOT NULL,
  `date_of_expected_return` datetime NOT NULL,
  `status` varchar(8) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `awaiting_reservations`
--

INSERT INTO `awaiting_reservations` (`id`, `car_id`, `account_id`, `date_of_rent_start`, `date_of_expected_return`, `status`) VALUES
(54, 4, 45, '2024-03-11 10:00:00', '2024-03-15 10:00:00', 'awaiting'),
(55, 1, 45, '2024-03-28 10:00:00', '2024-03-30 10:00:00', 'awaiting');

--
-- Wyzwalacze `awaiting_reservations`
--
DELIMITER $$
CREATE TRIGGER `test` AFTER UPDATE ON `awaiting_reservations` FOR EACH ROW INSERT INTO `active_reservations` (car_id, account_id, date_of_rent_start, date_of_expected_return, status) SELECT car_id, account_id, date_of_rent_start, date_of_expected_return, 'active' FROM `awaiting_reservations` WHERE awaiting_reservations.status='active'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cars`
--

CREATE TABLE `cars` (
  `id` bigint(11) NOT NULL,
  `brand` varchar(18) COLLATE utf8_polish_ci NOT NULL,
  `model` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `transmission` varchar(12) COLLATE utf8_polish_ci NOT NULL,
  `fuel_type` varchar(20) COLLATE utf8_polish_ci NOT NULL,
  `average_fuel_consumption` float NOT NULL,
  `number_of_doors` int(11) NOT NULL,
  `price_per_hour` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `cars`
--

INSERT INTO `cars` (`id`, `brand`, `model`, `transmission`, `fuel_type`, `average_fuel_consumption`, `number_of_doors`, `price_per_hour`) VALUES
(1, 'Audi', 'A4', 'Manualna', 'Diesel', 4.6, 5, 19.4),
(2, 'BMW', 'X4', 'Automatyczna', 'Diesel', 5.2, 5, 27.4),
(3, 'Chevrolet', 'Corvette C7', 'Manualna', 'Benzyna', 14.1, 3, 32.7),
(4, 'Mercedes-Benz', 'E', 'Automatyczna', 'Benzyna', 8.1, 5, 28.8),
(5, 'Audi', 'A6', 'Automatyczna', 'Diesel', 8.9, 5, 28.2),
(6, 'Bentley', 'Continental GT', 'Automatyczna', 'Benzyna', 14.5, 3, 54.5),
(7, 'Mercedes-Benz', 'C63 AMG', 'Automatyczna', 'Benzyna', 16.8, 3, 63.3),
(8, 'Lexus', 'LC 500', 'Automatyczna', 'Benzyna', 15.1, 3, 24.4);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `id` bigint(11) NOT NULL,
  `name` varchar(95) COLLATE utf8_polish_ci NOT NULL,
  `surname` varchar(40) COLLATE utf8_polish_ci NOT NULL,
  `email_address` varchar(60) COLLATE utf8_polish_ci NOT NULL,
  `password` varchar(512) COLLATE utf8_polish_ci NOT NULL,
  `account_type` varchar(13) COLLATE utf8_polish_ci NOT NULL,
  `account_status` varchar(8) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`id`, `name`, `surname`, `email_address`, `password`, `account_type`, `account_status`) VALUES
(43, 'admin', 'admin', 'admin@admin.pl', '$2y$10$C0vsHOGoYIFUcl91wYLhvOCn99//PcHyslqHkZSGnGJmt/Y0qAb1.', 'administrator', 'active'),
(44, 'mod', 'mod', 'mod@mod.pl', '$2y$10$gnEVgm5tHCC5ADYwcrk62OCdTEtUD39QfhZtoz0MmsQny2IrzJk5q', 'moderator', 'active'),
(45, 'user', 'user', 'user@user.pl', '$2y$10$I6no9Dlqp3C2W6ewrRSSdeMDsZ2OosIS1ZZVdgrj2myzjlx2pGjBy', 'klient', 'active');

--
-- Wyzwalacze `users`
--
DELIMITER $$
CREATE TRIGGER `account_status_update` AFTER UPDATE ON `users` FOR EACH ROW UPDATE `users_backup` SET `account_status`=new.account_status WHERE users_backup.id = old.id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `account_type_update` AFTER UPDATE ON `users` FOR EACH ROW UPDATE `users_backup` SET `account_type`=new.account_type WHERE users_backup.id = old.id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `user_insert` AFTER INSERT ON `users` FOR EACH ROW INSERT INTO `users_backup` (id, name, surname, email_address, password, account_type, account_status) VALUES(new.id, new.name, new.surname, new.email_address, new.password, new.account_type, new.account_status)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users_backup`
--

CREATE TABLE `users_backup` (
  `id` bigint(11) NOT NULL,
  `name` varchar(95) COLLATE utf8_polish_ci NOT NULL,
  `surname` varchar(40) COLLATE utf8_polish_ci NOT NULL,
  `email_address` varchar(60) COLLATE utf8_polish_ci NOT NULL,
  `password` varchar(512) COLLATE utf8_polish_ci NOT NULL,
  `account_type` varchar(13) COLLATE utf8_polish_ci NOT NULL,
  `account_status` varchar(8) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `users_backup`
--

INSERT INTO `users_backup` (`id`, `name`, `surname`, `email_address`, `password`, `account_type`, `account_status`) VALUES
(43, 'admin', 'admin', 'admin@admin.pl', '$2y$10$C0vsHOGoYIFUcl91wYLhvOCn99//PcHyslqHkZSGnGJmt/Y0qAb1.', 'administrator', 'active'),
(44, 'mod', 'mod', 'mod@mod.pl', '$2y$10$gnEVgm5tHCC5ADYwcrk62OCdTEtUD39QfhZtoz0MmsQny2IrzJk5q', 'moderator', 'active'),
(45, 'user', 'user', 'user@user.pl', '$2y$10$I6no9Dlqp3C2W6ewrRSSdeMDsZ2OosIS1ZZVdgrj2myzjlx2pGjBy', 'klient', 'active'),
(46, '', '', '', '$2y$10$E/nszLg9NVTwVRIOKydMiu97tDKhjBtKI3yBRXhV.B5IvNsTGmn32', 'klient', 'inactive'),
(47, '', '', '', '$2y$10$zk.VULBZi7wsISqCEd.QxOCg3XNm1Q7LR/hC0NUmK9YRT7WnjnZNC', 'klient', 'inactive'),
(48, 'd', 'd', 'd', '$2y$10$JNXhPfVDbWH9IstzUi76O.RR3JwFGLBYTqkaKMAVcTfoBvInPtLGq', 'klient', 'inactive'),
(49, 'd', 'd', 'd.d@d.gov.pl', '$2y$10$/LcbD.eGuagrPMyHPhADf.GvgiHTSt4jKieO6P8rY2kScrKyNZ8Tq', 'klient', 'inactive');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `active_reservations`
--
ALTER TABLE `active_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `car_id` (`car_id`);

--
-- Indeksy dla tabeli `archival_reservations`
--
ALTER TABLE `archival_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `car_id` (`car_id`);

--
-- Indeksy dla tabeli `awaiting_reservations`
--
ALTER TABLE `awaiting_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `car_id` (`car_id`);

--
-- Indeksy dla tabeli `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_address` (`email_address`);

--
-- Indeksy dla tabeli `users_backup`
--
ALTER TABLE `users_backup`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `active_reservations`
--
ALTER TABLE `active_reservations`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT dla tabeli `archival_reservations`
--
ALTER TABLE `archival_reservations`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT dla tabeli `awaiting_reservations`
--
ALTER TABLE `awaiting_reservations`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT dla tabeli `cars`
--
ALTER TABLE `cars`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `active_reservations`
--
ALTER TABLE `active_reservations`
  ADD CONSTRAINT `active_reservations_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `active_reservations_ibfk_3` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`);

--
-- Ograniczenia dla tabeli `archival_reservations`
--
ALTER TABLE `archival_reservations`
  ADD CONSTRAINT `archival_reservations_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `archival_reservations_ibfk_3` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`);

--
-- Ograniczenia dla tabeli `awaiting_reservations`
--
ALTER TABLE `awaiting_reservations`
  ADD CONSTRAINT `awaiting_reservations_ibfk_3` FOREIGN KEY (`account_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `awaiting_reservations_ibfk_4` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
