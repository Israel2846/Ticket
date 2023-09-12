-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-09-2023 a las 06:25:18
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
-- Estructura de tabla para la tabla `tm_tarea`
--

CREATE TABLE `tm_tarea` (
  `id_tarea` int(11) NOT NULL,
  `id_ticket` int(11) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL DEFAULT 13,
  `id_usuario_asignado` int(11) NOT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `tarea_titulo` varchar(50) NOT NULL,
  `tarea_desc` mediumtext NOT NULL,
  `fecha_finalizacion` datetime DEFAULT NULL,
  `estado_tarea` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_tarea`
--

INSERT INTO `tm_tarea` (`id_tarea`, `id_ticket`, `id_usuario`, `id_usuario_asignado`, `fecha_creacion`, `tarea_titulo`, `tarea_desc`, `fecha_finalizacion`, `estado_tarea`) VALUES
(21, 124, 13, 15, '2023-09-10 19:54:27', 'asdf', '<p>asdf</p>', '2023-09-10 19:57:07', 1),
(22, 123, 13, 16, '2023-09-10 20:03:00', 'asdf', '<p>asdf</p>', '2023-09-10 20:03:13', 1),
(23, 126, 13, 15, '2023-09-10 20:05:09', 'asdf', '<p>asdf</p>', '2023-09-10 20:05:38', 1),
(24, 124, 13, 16, '2023-09-10 20:06:37', 'asdf', '<p>asdf</p>', '2023-09-10 20:06:49', 1),
(25, 123, 13, 16, '2023-09-10 20:47:35', 'asdfasdf', '<p>asdfasdf</p>', '2023-09-10 20:48:18', 1),
(26, 125, 13, 15, '2023-09-11 19:32:16', 'asdf', '<p>asdf</p>', NULL, 1),
(27, NULL, 15, 0, '2023-09-11 21:58:44', 'asdf', '<p>asdf</p>', NULL, 1),
(28, NULL, 15, 0, '2023-09-11 21:59:48', 'asdf', '<p>asdf</p>', NULL, 1),
(29, 127, 15, 0, '2023-09-11 22:04:31', 'asdf', '<p>asdf</p>', NULL, 1),
(30, 125, 15, 0, '2023-09-11 22:05:01', 'faasdfasdf', '<p>asdfasdfasdf</p>', NULL, 1),
(31, 125, 15, 0, '2023-09-11 22:24:25', 'asdf', '<p>asdf</p>', NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  ADD PRIMARY KEY (`id_tarea`),
  ADD KEY `id_ticket` (`id_ticket`),
  ADD KEY `fk_id_usuario` (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  MODIFY `id_tarea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  ADD CONSTRAINT `fk_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `tm_usuario` (`usu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tm_tarea_ibfk_1` FOREIGN KEY (`id_ticket`) REFERENCES `tm_ticket` (`tick_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
