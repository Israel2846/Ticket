-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 09, 2023 at 09:56 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tickets`
--

-- --------------------------------------------------------

--
-- Table structure for table `tm_tarea`
--

CREATE TABLE `tm_tarea` (
  `id_tarea` int(11) NOT NULL,
  `id_ticket` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT 13,
  `id_usuario_asignado` int(11) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `tarea_titulo` varchar(50) NOT NULL DEFAULT 'Sin título',
  `tarea_desc` mediumtext NOT NULL DEFAULT 'Sin descripción',
  `fecha_finalizacion` datetime DEFAULT NULL,
  `estado_tarea` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Dumping data for table `tm_tarea`
--

INSERT INTO `tm_tarea` (`id_tarea`, `id_ticket`, `id_usuario`, `id_usuario_asignado`, `fecha_creacion`, `tarea_titulo`, `tarea_desc`, `fecha_finalizacion`, `estado_tarea`) VALUES
(25, 124, 13, 16, '2023-09-09 01:19:02', 'asdf', '<p>sdaf</p>', NULL, 1),
(26, 124, 13, 15, '2023-09-09 01:23:02', 'asdf', '<p>asdf</p>', NULL, 1),
(27, 124, 13, 16, '2023-09-09 01:24:41', 'asdf', '<p>asdf</p>', NULL, 1),
(28, 125, 13, 16, '2023-09-09 01:53:12', 'asdf', '<p>asdf</p>', NULL, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tm_tarea`
--
ALTER TABLE `tm_tarea`
  ADD PRIMARY KEY (`id_tarea`),
  ADD KEY `id_ticket` (`id_ticket`),
  ADD KEY `fk_id_usuario` (`id_usuario`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tm_tarea`
--
ALTER TABLE `tm_tarea`
  MODIFY `id_tarea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tm_tarea`
--
ALTER TABLE `tm_tarea`
  ADD CONSTRAINT `fk_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `tm_usuario` (`usu_id`),
  ADD CONSTRAINT `tm_tarea_ibfk_1` FOREIGN KEY (`id_ticket`) REFERENCES `tm_ticket` (`tick_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
