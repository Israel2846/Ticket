-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-09-2023 a las 06:33:54
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tickets`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_pausas_ticket`
--

CREATE TABLE `td_pausas_ticket` (
  `pausas_ticket_id` int(11) NOT NULL,
  `id_ticket` int(11) NOT NULL,
  `fecha_pausa` datetime DEFAULT NULL,
  `fecha_reanuda` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `td_pausas_ticket`
--

INSERT INTO `td_pausas_ticket` (`pausas_ticket_id`, `id_ticket`, `fecha_pausa`, `fecha_reanuda`) VALUES
(10, 132, '2023-09-13 21:11:25', NULL),
(11, 132, '2023-09-13 21:30:41', '2023-09-13 21:30:49'),
(12, 128, '2023-09-13 21:49:27', '2023-09-13 22:28:18'),
(13, 131, '2023-09-13 22:20:55', '2023-09-13 22:21:26'),
(14, 131, '2023-09-13 22:21:36', '2023-09-13 22:21:52'),
(15, 131, '2023-09-13 22:22:50', '2023-09-13 22:23:06'),
(16, 131, '2023-09-13 22:23:42', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `td_pausas_ticket`
--
ALTER TABLE `td_pausas_ticket`
  ADD PRIMARY KEY (`pausas_ticket_id`),
  ADD KEY `fk_id_ticket` (`id_ticket`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `td_pausas_ticket`
--
ALTER TABLE `td_pausas_ticket`
  MODIFY `pausas_ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `td_pausas_ticket`
--
ALTER TABLE `td_pausas_ticket`
  ADD CONSTRAINT `fk_id_ticket` FOREIGN KEY (`id_ticket`) REFERENCES `tm_ticket` (`tick_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
