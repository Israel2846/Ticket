-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-12-2023 a las 23:09:21
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

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
-- Estructura de tabla para la tabla `td_documento`
--

CREATE TABLE `td_documento` (
  `doc_id` int(11) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `doc_nom` varchar(400) NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento_detalle`
--

CREATE TABLE `td_documento_detalle` (
  `det_id` int(11) NOT NULL,
  `tickd_id` int(11) NOT NULL,
  `det_nom` varchar(200) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento_tarea`
--

CREATE TABLE `td_documento_tarea` (
  `id_documento_tarea` int(11) NOT NULL,
  `id_tarea` int(11) NOT NULL,
  `nom_doc` varchar(400) NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento_tarea_detalle`
--

CREATE TABLE `td_documento_tarea_detalle` (
  `id_tarea_detalle` int(11) NOT NULL,
  `id_tarea` int(11) NOT NULL,
  `nom_det` varchar(200) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_pausas_ticket`
--

CREATE TABLE `td_pausas_ticket` (
  `pausas_ticket_id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_ticket` int(11) NOT NULL,
  `fecha_pausa` datetime DEFAULT NULL,
  `fecha_reanuda` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_tareadetalle`
--

CREATE TABLE `td_tareadetalle` (
  `tareadetalle_id` int(11) NOT NULL,
  `tarea_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `tarea_desc` mediumtext NOT NULL,
  `fecha_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_ticketdetalle`
--

CREATE TABLE `td_ticketdetalle` (
  `tickd_id` int(11) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `tickd_descrip` mediumtext NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_almacen`
--

CREATE TABLE `tm_almacen` (
  `id_almacen` int(11) NOT NULL,
  `nombre_almacen` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_almacen`
--

INSERT INTO `tm_almacen` (`id_almacen`, `nombre_almacen`) VALUES
(1, 'Solulogis del Sureste'),
(2, 'Almacen CCO AIFA'),
(3, 'Almacen CCO AICM'),
(4, 'Solulogis Cabos'),
(5, 'Almacen SAASA AICM');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_area_almacen`
--

CREATE TABLE `tm_area_almacen` (
  `id_area_almacen` int(11) NOT NULL,
  `id_almacen` int(11) NOT NULL,
  `nombre_area` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_area_almacen`
--

INSERT INTO `tm_area_almacen` (`id_area_almacen`, `id_almacen`, `nombre_area`) VALUES
(1, 1, 'Sistemas'),
(2, 2, 'Sistemas'),
(3, 3, 'Sistemas'),
(4, 2, 'Almacen'),
(5, 2, 'Intendencia'),
(6, 2, 'Administrativo'),
(7, 2, 'Operativo'),
(8, 5, 'Almacen'),
(9, 5, 'Intendencia'),
(10, 5, 'Administrativo'),
(11, 5, 'Operativo'),
(12, 5, 'Sistemas'),
(13, 3, 'Almacen'),
(14, 3, 'Intendencia'),
(15, 3, 'Administrativo'),
(16, 3, 'Operativo'),
(17, 1, 'Implementación');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_categoria`
--

CREATE TABLE `tm_categoria` (
  `cat_id` int(11) NOT NULL,
  `cat_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_categoria`
--

INSERT INTO `tm_categoria` (`cat_id`, `cat_nom`, `est`) VALUES
(1, 'Hardware', 1),
(2, 'Software', 1),
(3, 'Incidencia', 1),
(4, 'Petición de Servicio', 1),
(5, 'Proyecto', 1),
(6, 'SCAF', 1),
(7, 'Impresoras', 1),
(8, 'CONTPAQ ', 1),
(9, 'Correo', 1),
(10, 'Compras', 1),
(11, 'Documentación', 1),
(12, 'Equipo móvil', 1),
(13, 'Apple', 1),
(14, 'Intelisis', 1),
(15, 'Otros', 0),
(16, 'NAS', 0),
(17, 'Otro', 1),
(18, 'NAS', 0),
(19, 'NAS', 1),
(20, 'Soporte', 1),
(21, 'Red', 1),
(22, 'C. Pedimentos', 1),
(23, 'CCTV', 1),
(24, 'Spy4u', 1),
(25, 'Torniquete', 1),
(26, 'Disco Duro', 1),
(27, 'PC', 1),
(28, 'SITE', 1),
(29, 'Equipos', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_notificacion`
--

CREATE TABLE `tm_notificacion` (
  `not_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `not_mensaje` varchar(400) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_prioridad`
--

CREATE TABLE `tm_prioridad` (
  `prio_id` int(11) NOT NULL,
  `prio_nom` varchar(50) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_prioridad`
--

INSERT INTO `tm_prioridad` (`prio_id`, `prio_nom`, `est`) VALUES
(1, 'Alta', 1),
(2, 'Media', 1),
(3, 'Baja', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_subcategoria`
--

CREATE TABLE `tm_subcategoria` (
  `cats_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_subcategoria`
--

INSERT INTO `tm_subcategoria` (`cats_id`, `cat_id`, `cats_nom`, `est`) VALUES
(1, 1, 'Teclado', 1),
(2, 1, 'Monitor', 1),
(3, 3, 'Corte de Red', 1),
(4, 3, 'Corte de Energia', 1),
(5, 2, 'Microsoft Office', 1),
(6, 4, 'Instalación de IIS', 1),
(7, 5, 'Gestor de Tickets', 1),
(9, 2, 'Impresoras báscula', 1),
(10, 6, 'Timbrado de factura', 1),
(11, 6, 'Cambio de House', 1),
(12, 6, 'Cambio de Máster', 1),
(13, 6, 'Inserción de datos', 1),
(14, 6, 'Cambio de papeleta', 1),
(15, 6, 'Eliminación de datos', 1),
(16, 6, 'Duplicado de datos', 1),
(17, 1, 'Mouse', 1),
(18, 7, 'Etiquetas', 1),
(19, 7, 'Proveedor', 1),
(20, 7, 'Tóner/Ribbon ', 1),
(21, 7, 'Ribbon', 0),
(22, 7, 'Soporte', 1),
(23, 8, 'Comercial', 1),
(24, 8, 'Contabilidad', 1),
(25, 8, 'Nomina', 1),
(26, 9, 'CPANEL', 1),
(27, 9, 'Firma', 1),
(28, 9, 'IMAP', 1),
(29, 9, 'POP', 1),
(30, 9, 'PST/OST', 1),
(31, 10, 'Office', 0),
(32, 10, 'Windows', 1),
(33, 10, 'PC Escritorio', 1),
(34, 10, 'Software', 1),
(35, 10, 'Licencias', 1),
(36, 10, 'Laptop', 1),
(37, 10, 'Hardware', 1),
(38, 11, 'Memoria Técnica', 1),
(39, 11, 'Reportes', 1),
(40, 12, 'HandHeld', 1),
(41, 12, 'Tableta', 1),
(42, 13, 'iMac', 1),
(43, 13, 'iPad', 1),
(44, 13, 'iPhone', 1),
(45, 13, 'MacBook', 1),
(46, 2, 'SAP Palace', 1),
(47, 2, 'WMS', 1),
(48, 2, 'UltraSite', 1),
(49, 5, 'Infraestructura y cableado de red', 1),
(50, 17, 'Otros', 1),
(51, 19, 'Cancún', 1),
(52, 19, 'AICM', 1),
(53, 19, 'AIFA', 1),
(54, 19, 'Cabos', 1),
(55, 18, 'Carga de archivos', 0),
(56, 2, 'Otro', 1),
(57, 20, 'Apoyo Usuarios', 1),
(58, 5, 'Migración de Correos', 1),
(59, 9, 'Contraseña', 1),
(60, 21, 'Antenas', 1),
(61, 2, 'Carpeta Compartida', 1),
(62, 8, 'Bancos', 1),
(63, 2, 'Pensus', 1),
(64, 22, 'Validador', 1),
(65, 23, 'Extracciones ', 1),
(66, 24, 'Enfoque de Cámaras', 1),
(67, 24, 'Cámaras Compartidas', 1),
(68, 25, 'Registrar Usuarios', 1),
(69, 25, 'Sincronizar Datos', 1),
(70, 25, 'Base de Datos', 1),
(71, 26, 'Respaldo', 1),
(72, 27, 'Instalación de Windows', 1),
(73, 27, 'Instalar equipos ', 1),
(74, 28, 'Mantenimiento', 1),
(75, 21, 'Reconectar Equipos ', 1),
(76, 29, 'Relación de Datos', 1),
(77, 27, 'Relación de Datos', 1),
(78, 27, 'Contraseñas', 1),
(79, 23, 'Imagen en Monitores ', 1),
(80, 1, 'Cámara de Video', 1),
(81, 1, 'Antenas', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_tarea`
--

CREATE TABLE `tm_tarea` (
  `id_tarea` int(11) NOT NULL,
  `id_ticket` int(11) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL DEFAULT 13,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `tarea_titulo` varchar(50) NOT NULL,
  `tarea_desc` mediumtext NOT NULL,
  `fecha_finalizacion` datetime DEFAULT NULL,
  `estado_tarea` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_ticket`
--

CREATE TABLE `tm_ticket` (
  `tick_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_id` int(11) NOT NULL,
  `tick_titulo` varchar(250) NOT NULL,
  `tick_descrip` mediumtext NOT NULL,
  `tick_estado` varchar(15) DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `usu_asig` int(11) DEFAULT NULL,
  `fech_asig` datetime DEFAULT NULL,
  `tick_estre` int(11) DEFAULT NULL,
  `tick_coment` varchar(300) DEFAULT NULL,
  `fech_cierre` datetime DEFAULT NULL,
  `prio_id` int(11) DEFAULT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_usr_cat`
--

CREATE TABLE `tm_usr_cat` (
  `id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `rol_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_usuario`
--

CREATE TABLE `tm_usuario` (
  `usu_id` int(11) NOT NULL,
  `usu_nom` varchar(150) DEFAULT NULL,
  `usu_ape` varchar(150) DEFAULT NULL,
  `num_colab` varchar(10) NOT NULL DEFAULT 'Sin numero',
  `usu_correo` varchar(150) NOT NULL,
  `usu_pass` varchar(150) NOT NULL,
  `usu_almacen` int(150) DEFAULT NULL,
  `usu_area` int(150) DEFAULT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `usu_telf` varchar(12) NOT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `fech_modi` datetime DEFAULT NULL,
  `fech_elim` datetime DEFAULT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla Mantenedor de Usuarios';

--
-- Volcado de datos para la tabla `tm_usuario`
--

INSERT INTO `tm_usuario` (`usu_id`, `usu_nom`, `usu_ape`, `num_colab`, `usu_correo`, `usu_pass`, `usu_almacen`, `usu_area`, `rol_id`, `usu_telf`, `fech_crea`, `fech_modi`, `fech_elim`, `est`) VALUES
(1, 'Jorge', 'Gala', '1440', 'soporteit@solulogis.com', 'f4a331b7a22d1b237565d8813a34d8ac', 1, 1, 2, '9981265517', '2023-10-02 12:01:52', '2023-10-02 12:02:08', NULL, 1),
(2, 'Héctor', 'González', '1797', 'aux-sist4@solulogis.com', '8d9fc2308c8f28d2a7d2f6f48801c705', 1, 1, 2, '9981265863', '2023-10-02 11:04:15', NULL, NULL, 1),
(3, 'Israel', 'Colin', '2846', 'aux-sist-aifa1@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 2, '5517600294', '2023-10-02 11:15:45', NULL, NULL, 1),
(4, 'Arby', 'Pat', '0088', 'arby.pat@solulogis.com', '47fb33421eb25052e477ab7bbc53e72f', 1, 1, 2, '9982424145', '2023-10-02 11:23:32', NULL, NULL, 1),
(5, 'Gabriel', 'Mellado', '12345', 'gmellado@cco.com.mx', '827ccb0eea8a706c4c34a16891f84e7b', 3, 3, 3, '5512345678', '2023-10-06 12:39:12', NULL, NULL, 1),
(6, 'Mildreth', 'Ponciano', '77', 'mildreth.ponciano@cco.com.mx', '28dd2c7955ce926456240b2ff0100bde', 2, 4, 3, '5566316591', '2023-10-06 14:19:50', NULL, NULL, 1),
(7, 'Jocelin', 'Galván', '66', 'aux-sist-aifa2@cco.com.mx', '3295c76acbf4caaed33c36b1b5fc2cb1', 2, 2, 2, '5512345678', '2023-10-06 15:00:38', NULL, NULL, 1),
(8, 'Christopher ', 'Durán', 'AF-144', 'cristopher.duran@cco.com.mx', '2587a2eb7c437c1e43f97aef715c0cfa', 2, 2, 3, '5586161310', '2023-10-06 17:31:40', NULL, NULL, 1),
(9, 'Diego', 'Rosas', '12345', 'aux-sist-aicm2@cco.com.mx', '827ccb0eea8a706c4c34a16891f84e7b', 3, 3, 2, '5546968170', '2023-10-09 14:12:35', NULL, NULL, 1),
(11, 'Fernanda', 'Lopez', '12345', 'aux-sist-aicm1@cco.com.mx', '827ccb0eea8a706c4c34a16891f84e7b', 3, 3, 1, '5546968170', '2023-10-09 14:15:31', NULL, NULL, 1),
(12, 'Rodrigo', 'Amaro', '1759', 'aux-sist1@solulogis.com', 'ba1b3eba322eab5d895aa3023fe78b9c', 1, 1, 2, '018009998080', '2023-10-09 14:36:09', NULL, NULL, 1),
(13, 'Jesus Francisco', 'Acuautla Sanchez', 'SC-42', 'jesusfrancisco@cco.com.mx', '9e9dddc63e3bad3d8125a2befb4bd876', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(14, ' Alejandro ', 'Arango Gabriel', 'SC-48', 'alejandro@cco.com.mx', 'e1da06639aa3b8d11513584c2d232a16', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(15, 'Gian Aldrick', 'Arguelles Franco', 'SC-27', 'gianaldrick@cco.com.mx', '23c08883e88fe5a9def45eeb860ba9f9', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(16, 'Cecilia', 'Arzate Diaz', 'SC-29', 'cecilia@cco.com.mx', 'e731a915a46565e87c5fba36458b1d33', 5, 9, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(17, 'Blanca Yanet', 'Barroso Castro', 'SC-52', 'blancayanet@cco.com.mx', 'dd5f5e5e6d8fd026db1e231e38654349', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(18, 'Jose Alfredo', 'Becerril Marquez', 'SC-45', 'josealfredo@cco.com.mx', '8dfac160c4646f0a14483ce0a6a51b0f', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(19, 'Abiram Shibolet', 'Bravo Miranda', 'SC-24', 'abiramshibolet@cco.com.mx', 'f3ed07709265ceb97aacee045ba0477b', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(20, 'Erick Martin', 'Caballero Ramirez', 'SC-03', 'erickmartin@cco.com.mx', '642fff995244418e7fda8a6d6087aa9b', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(21, 'Cynthia Daniela', 'Caseres Lara', 'SC-19', 'cynthiadaniela@cco.com.mx', 'd1b9f0076a858d8d8ad7fb61f2d2a736', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(22, 'Gabriela Abigail', 'Castillo Castillo', 'SC-13', 'gabrielaabigail@cco.com.mx', '51c739bf08700aabef12895daab7bd24', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(23, 'Alvaro Adrian', 'Castro Arellano', 'SC-10', 'alvaroadrian@cco.com.mx', 'ef6d3a7e58c3a70a730018470e7e2dd3', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(24, 'Brandon Cristopher', 'Cedillo Rodriguez', 'SC-53', 'brandoncristopher@cco.com.mx', '415383f393ca339a7238f9176629cabc', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(25, 'Hector Miguel', 'Corona Rendon', 'SC-35', 'hectormiguel@cco.com.mx', '46eb01660101e94688faf502134e0b1f', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(26, 'Jose Manuel', 'Cortes Vazquez', 'SC-04', 'josemanuel@cco.com.mx', '7de640394427a3c251154c57eab9500b', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(27, 'Miguel Angel', 'Cruz Ferreira', 'SC-25', 'miguelangel@cco.com.mx', 'fb7f77b7e2ee7c7165f30ec04fe19afa', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(28, 'Karla Ximena', 'Diaz Salas', 'SC-50', 'karlaximena@cco.com.mx', '7f9f44a01bb57f769280953fd8a19834', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(29, 'Jesus', 'Dorado Hernandez', 'SC-32', 'jesus@cco.com.mx', '5e56facb9cbab7eedf0c254d7deed229', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(30, 'Luis Edwin', 'Galindo Ramirez', 'SC-05', 'luisedwin@cco.com.mx', '661a1d16fec5420aa66ffe7224aa8dfa', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(31, 'Ailyn Daniela ', 'Gutierrez Garcia', 'SC-39', 'ailyndaniela@cco.com.mx', 'c1724c65c0f7a96898309dd01dd26b43', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(32, 'Jose Ricardo', 'Gutierrez Sanchez', 'SC-06', 'josericardo@cco.com.mx', '61ca83039318fc6af8418afb8e397f45', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(33, 'Alexis ', 'Hernandez Perez', 'SC-33', 'alexis@cco.com.mx', '13034cc2a0726f9f822bd51d2f52cebe', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(34, 'Brandon Antonio', 'Martinez Garcia', 'SC-11', 'brandonantonio@cco.com.mx', 'ae190cccc8b8a2f139a1cb439168eba7', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(35, 'Oscar ', 'Martinez Valadez', 'SC-46', 'oscar@cco.com.mx', '444345c7d48b1e0b00e6b930cc39d04f', 5, 9, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(36, 'Gabriel Alejandro', 'Mellado Martinez', 'SC-07', 'gabrielalejandro@cco.com.mx', 'bc9909e0e1ffc6987e42c7a6c8e357c9', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(37, 'Myriam Sarai', 'Montor Pineda', 'SC-08', 'myriamsarai@cco.com.mx', '17fa9741c650d8acc990d84143e7a7e7', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(38, 'Oscar', 'Nava Hernandez', 'SC-16', 'oscar@cco.com.mx', 'a00a7182d9d1590a20c11dd678196fa8', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(39, 'Jorge Antonio', 'Obregon Rodriguez', 'SC-09', 'jorgeantonio@cco.com.mx', 'd4e7984b8047a7addcf2d9ba2016918e', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(40, 'Alejandro', 'Ochoa Serrano', 'SC-28', 'alejandro@cco.com.mx', '094c55cd4980fdaef1632979a5c98f31', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(41, 'Maria Yoali', 'Perez Rivera', 'SC-47', 'mariayoali@cco.com.mx', 'a10756858b1ac288bd28d23b630e3374', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(42, 'Jose Antonio', 'Piñon Ridriguez', 'SC-21', 'joseantonio@cco.com.mx', '93cbf21c7d5164c0f2426863b00e8de4', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(43, 'Damian Paul', 'Portilla Valencia', 'SC-43', 'damianpaul@cco.com.mx', 'ee0d5fe66d957c2191bf3a2533c9e13b', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(44, 'Rocio', 'Ramirez Flores', 'SC-01', 'rocio@cco.com.mx', '82225881e6993f6ca816dd72a09323d0', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(45, 'Jesus Vicente', 'Rendon Acosta', 'SC-14', 'jesusvicente@cco.com.mx', 'e365f057f62571f240451b9a4cf7c210', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(46, 'Jorge Osmain', 'Rivas Gonzalez', 'SC-40', 'jorgeosmain@cco.com.mx', 'e26447750f5404bc400bf6d50eed055c', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(47, 'Heriberto', 'Rodriguez Cortes', 'SC-30', 'heriberto@cco.com.mx', '9831b86a96484740fbd8e58326e53084', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(48, 'Rair Jesus', 'Rodriguez Ortiz', 'SC-12', 'rairjesus@cco.com.mx', 'f52823e4325bfc05e3816737f0b328cc', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(49, 'Angel', 'Rodriguez Perez', 'SC-02', 'angel@cco.com.mx', 'd235b3cdab685e29a4ef0f2b243ca6dc', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(50, 'Diego Fabian', 'Segura Olvera', 'SC-44', 'diegofabian@cco.com.mx', 'e13ac2b94ca07717aaa2567f0a2d7735', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(51, 'Erik', 'Tapia Garcia', 'SC-49', 'erik@cco.com.mx', '9879b8e82e2f43eb7a8af2b85a1a1417', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(52, 'Mayte', 'Torres Arenas', 'SC-15', 'mayte@cco.com.mx', 'fb0b2e65be07c57d59e948a670fa3e3e', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(53, 'Fernanda', 'Torres Perales', 'SC-26', 'fernanda@cco.com.mx', '6c58452476c6c2ed355ae7910c4c87d3', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(54, 'Alan Daniel', 'Velazquez Uribe', 'SC-17', 'alandaniel@cco.com.mx', '07840c30f05b9d5d5e25008ba647e05f', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(55, 'Edgar Manuel', 'Villalba Caballero', 'SC-51', 'edgarmanuel@cco.com.mx', '8668b079afdc7ed6d14ad67940e57f09', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(56, 'David', 'Villegas Correa', 'SC-22', 'david@cco.com.mx', 'bafd78001e584733beb2e5204e78b2a2', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(57, 'Emilio Felipe', 'Abarca Ortiz', 'AF-04', 'emiliofelipe@cco.com.mx', '492f8e9963f2832da4f26b6c22e7d0bb', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(58, 'Vanessa Xaneiry', 'Aguilar Barrera', 'AF-41', 'vanessaxaneiry@cco.com.mx', '3b1c8a61fa6119604cae6b38ad6562cc', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(59, ' Edgar Teodoro ', 'Andrade Torres', 'AF-264', 'edgarteodoro@cco.com.mx', '6e176e3548df0e60cae34a57b1f7c927', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(60, 'Elda Sarahi', 'Arenas Martinez', 'AF-139', 'eldasarahi@cco.com.mx', 'ebc15181437362a33b81d8c0200edd66', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(61, 'Diana', 'Armendariz Sandoval', 'AF-42', 'diana@cco.com.mx', '5e3502bb8803f77ddf1e9259bf7e3ed0', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(62, 'Omar Adrian', 'Arriaga Torres', 'AF-195', 'omaradrian@cco.com.mx', 'a0a4c18b3d5103d2e0de135e36947702', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(63, 'Jonathan Francisco ', 'Arrieta Gutierrez', 'AF-137', 'jonathanfrancisco@cco.com.mx', 'b912aef0e00542fbd692d1b24a8efd81', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(64, 'Jesus Enrique ', 'Arroyo Cazares', 'AF-233', 'jesusenrique@cco.com.mx', '84a59af45ffc46112a98af1b6a25652e', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(65, 'Brayan', 'Ayala Sanchez', 'AF-244', 'brayan@cco.com.mx', '244a36729bd1764cf2c354b3e61474d8', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(66, 'Yovanni Gaciel ', 'Ayehualtencatl Peña', 'AF-235', 'yovannigaciel@cco.com.mx', '463ad2ccc00097633d7e1e89ef66b662', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(67, 'Maria Daniel ', 'Badillo Santa', 'AF-246', 'mariadaniel@cco.com.mx', '4e2c9aff75a9506b4066eea7c62d8ef1', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(68, 'Jonathan', 'Barragan Gonzalez', 'AF-58', 'jonathan@cco.com.mx', 'a68b8003ff723e6c13c563f6e333530b', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(69, 'Rebeca Jazmine', 'Bermudez Galindo', 'AF-155', 'rebecajazmine@cco.com.mx', '83bb83bbf201425bab3139366fe03388', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(70, 'Gabriel', 'Bolañoz Martinez', 'AF-25', 'gabriel@cco.com.mx', '78eec9e14b82ad3280d37aaf95867797', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(71, 'Margarita ', 'Botello Muñoz', 'AF-167', 'margarita@cco.com.mx', 'c5ac5505f232135946953a87e3aa7e37', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(72, 'Eduardo', 'Brendel Rodriguez', 'AF-247', 'eduardo@cco.com.mx', '8833c8c6a70eb60b3b6058a65a494a74', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(73, 'Luis Angel ', 'Cabrera Santos', 'AF-111', 'luisangel@cco.com.mx', '465faab403d31a00e1d686ea861c6410', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(74, 'Santiago de Jesus', 'Cabrera Vilchis', 'AF-199', 'santiagodejesus@cco.com.mx', '20fc277c72648f14ccfeca2d4384b6ed', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(75, 'Alan Manuel', 'Calderon Tello', 'AF-187', 'alanmanuel@cco.com.mx', '33382f4b5d994e253353ec8076331f1f', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(76, 'Victor Damian', 'Caloca Salvador', 'AF-32', 'victordamian@cco.com.mx', '9aac3c26559f59a242a0534aea4e1915', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(77, 'Ricardo Daniel ', 'Camacho Olvera', 'AF-132', 'ricardodaniel@cco.com.mx', 'd8783cf2e1f3556be4eebd4a9b1be0ae', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(78, 'Cesar Tlatoani', 'Canales Cruz', 'AF-29', 'cesartlatoani@cco.com.mx', '910b66cf779b43b847f2e519d71bb6f3', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(79, 'Alberto ', 'Cano Negrete', 'AF-84', 'alberto@cco.com.mx', '74f9adbfed331151d0693c53c5593815', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(80, 'Brayan Abdiel', 'Castro Caballero', 'AF-248', 'brayanabdiel@cco.com.mx', '38d19928d85fd398c38c6a5db40fd0e6', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(81, 'Jean Israel', 'Castro Rodriguez', 'AF-09', 'jeanisrael@cco.com.mx', '988d52a97b8b318946dc85f2afb03f58', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(82, 'Abel Armando', 'Chavez Guzman', 'AF-3639', 'abelarmando@cco.com.mx', '06bf7d2d5914bf8d466d504fca31616f', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(83, 'Victor Hugo ', 'Chavez Guzman', 'AF-2396', 'victorhugo@cco.com.mx', '20e372a5dac23a459ab42240eeae3abe', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(84, 'Daniel', 'Contreras Caballero', 'AF-191', 'daniel@cco.com.mx', '1c768e9748d38d3792d92f35911cb627', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(85, 'Julio Cesar', 'Cuevas Cerritos', 'AF-81', 'juliocesar@cco.com.mx', 'ddec89a6463980178452da2c603f1657', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(86, 'Roberto ', 'Davila Martinez', 'AF-98', 'roberto@cco.com.mx', 'f707ac1e1ecfa7fe6f8e772e22706794', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(87, 'Hernandez Christian', 'Del Campo', 'AF-156', 'hernandezchristian@cco.com.mx', '451cad33f5f38f1b812652ddb67aeeaf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(88, 'Marin Hugo Cesar ', 'Del Rio', 'AF-204', 'marinhugocesar@cco.com.mx', '079797a5022ea199d7a94088b908a8f1', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(89, 'Ariana ', 'Delgadillo Galvan', 'AF-89', 'ariana@cco.com.mx', 'de341f62ec1e9160439b9687882ed879', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(90, 'Nelibeth Bibiana', 'Diaz Ledezma', 'AF-86', 'nelibethbibiana@cco.com.mx', '132c696b17da96398029865bb8fcd764', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(91, 'Elizabeth ', 'Dominguez Gallardo', 'AF-2401', 'elizabeth@cco.com.mx', 'd5ac7fe2e5fdf0f21a6d81aff29fa4c7', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(92, 'Rosa Araceli', 'Dominguez Hernandez', 'AF-44', 'rosaaraceli@cco.com.mx', 'a37fe851fe50c7a8bbc5596131663ade', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(93, 'Arturo Emanuel', 'Dorado Hernandez', 'AF-69', 'arturoemanuel@cco.com.mx', '9c0554a3948822952962212ad28315a4', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(94, 'Alejandro Alonso ', 'Duran Hipolito', 'AF-210', 'alejandroalonso@cco.com.mx', '2e23557c680a42cddabcacd422d922da', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(95, 'Michel', 'Duran Olmedo', 'AF-74', 'michel@cco.com.mx', '9766a5a812bd1e5715d555a0fe42231e', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(96, 'Mario', 'Espinosa Gomez', 'AF-196', 'mario@cco.com.mx', '2ab7deba513d06ed3fba219e2d290add', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(97, 'Francisco ', 'Espinosa Ramirez', 'AF-138', 'francisco@cco.com.mx', 'b847be89658da8a604929120f918e274', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(98, 'Jose Francisco', 'Flores Hernandez', 'AF-223', 'josefrancisco@cco.com.mx', 'baaeb262b82189a8cc4a4cdf40c461df', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(99, 'Emanuel', 'Flores Salgado', 'AF-55', 'emanuel@cco.com.mx', '36be7f63aa59273bcf0a58d131fa1704', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(100, 'Jonathan Uriel ', 'Galicia Cruz', 'AF-218', 'jonathanuriel@cco.com.mx', '5ff2cc05d81ed4cd5563c871b4b453fc', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(101, 'Xitlali', 'Gama Jimenez', 'AF-18', 'xitlali@cco.com.mx', '27d219e6d4c3dcfbc4c4d1baaf01276e', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(102, 'Alan Uriel ', 'Garcia Alonso', 'AF-217', 'alanuriel@cco.com.mx', 'dbd60d99d475c5c5722b884652b0faa4', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(103, 'Angel Martin ', 'Garcia Bautista', 'AF-207', 'angelmartin@cco.com.mx', 'afa5f81a359e56cfde8b59f07ef5466a', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(104, 'Luis Roberto ', 'Garcia Bautista', 'AF-249', 'luisroberto@cco.com.mx', 'e4464377ba4f8c51c45815a2ca9ac62c', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(105, 'Eduardo Daniel ', 'Garcia Garcia', 'AF-250', 'eduardodaniel@cco.com.mx', 'cb0bb853d445aab3231610b847967ea6', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(106, 'Andres', 'Garcia Hernandez', 'AF-93', 'andres@cco.com.mx', 'f035151514dc500c69b5a4da4d96e3ba', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(107, 'Mario Yahir', 'Garcia Juarez', 'AF-03', 'marioyahir@cco.com.mx', '625fce0923dc862b2742e4a00d5d2ee3', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(108, 'Manuel Arturo', 'Garcia Martinez', 'AF-22999', 'manuelarturo@cco.com.mx', 'decda5d3df4bcab5ae7340baefea2f20', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(109, 'Gloria', 'Garcia Serna', 'AF-21', 'gloria@cco.com.mx', '77f94713ddf6f10d1856e28cbae4bed1', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(110, 'Andrik Uriel', 'Garcia Serrano', 'AF-37', 'andrikuriel@cco.com.mx', '87f31dcf19a95cd697343004002171ec', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(111, 'Ulises Adrian', 'Garcia Serrano', 'AF-08', 'ulisesadrian@cco.com.mx', 'a711608b92c1c6599f78834628878324', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(112, 'Juan Carlos', 'Garcia Venegas', 'AF-22492', 'juancarlos@cco.com.mx', 'eb2feee3ec320f3f64d9a678a4b4b37a', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(113, 'Juan Jose', 'Garcia Venegas', 'AF-190', 'juanjose@cco.com.mx', 'c139e1c080ee73b28781b69ca17d50d5', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(114, 'Victor Antonio ', 'Garcia Xicali', 'AF-237', 'victorantonio@cco.com.mx', '0b3b3bfdf985d3fe1203a1e66e512f4a', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(115, 'Jose Maria', 'Garibay Aparicio', 'AF-23206', 'josemaria@cco.com.mx', 'fab56b6cc7b017d3b4d1db6187349120', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(116, 'Jesus Aldair', 'Garnica Hernandez', 'AF-23', 'jesusaldair@cco.com.mx', '8b8d6c3d752ed40694721b9aff93b824', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(117, 'Jonathan ', 'Garrido Perez', 'AF-2396', 'jonathan@cco.com.mx', '20e372a5dac23a459ab42240eeae3abe', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(118, 'Valetin ', 'Gayosso Soto', 'AF-236', 'valetin@cco.com.mx', '443953d7214d15b9904d6fd3f475f29e', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(119, 'Alexis Aldair ', 'Gomez Chavez', 'AF-173', 'alexisaldair@cco.com.mx', '6492d054856611404f2f26c398278115', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(120, 'Luis Alberto', 'Gonzalez Gutierres', 'AF-245', 'luisalberto@cco.com.mx', 'e08555947a08b7fed0aa84fd4a325b68', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(121, 'Alan Diego', 'Gonzalez Hernandez', 'AF-182', 'alandiego@cco.com.mx', '0468ef0ae096d6434e9a1e7f80be9024', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(122, 'Juan Carlos ', 'Gonzalez Lopez', 'AF-23035', 'juancarlos@cco.com.mx', 'c7008ac74f8e5231df09caf72cd6c166', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(123, 'Mario Walfred', 'Gonzalez Lopez', 'AF-251', 'mariowalfred@cco.com.mx', '7dde21c86060d3d6a4a2edc5540eaf34', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(124, 'Erika Naivid', 'Gonzalez Maldonado', 'AF-153', 'erikanaivid@cco.com.mx', '399633aea7ec566588ad8d432748daa3', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(125, 'Armando Yair', 'Gonzalez Muñoz', 'AF-186', 'armandoyair@cco.com.mx', 'cc5ca2b269c205722e663500e9ba1dc6', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(126, 'Josue Ismael ', 'Gonzalez Samaniego', 'AF-157', 'josueismael@cco.com.mx', '9b1023f63f56b0de86c4ab37d2511cd0', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(127, 'Joel ', 'Gonzalez Ventura', 'AF-206', 'joel@cco.com.mx', '2fc4e945fed2a332729804a8739105b3', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(128, 'Eduardo', 'Guerrero Fuentes', 'AF-13', 'eduardo@cco.com.mx', '09753f9ae3403c148b34c85083bfdd27', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(129, 'Ricardo', 'Guerrero Garcia', 'AF-166', 'ricardo@cco.com.mx', 'eaef6efa2edfedcff55f53e66ea3c05b', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(130, 'Miguel Angel ', 'Gutierrez Brizuela', 'AF-125', 'miguelangel@cco.com.mx', '989e4df3e901c37bfae259d9d0b2eaa5', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(131, 'Edgar Martin', 'Gutierrez Diaz', 'AF-73', 'edgarmartin@cco.com.mx', '75a0339764fdcf0c48ec83be6861b791', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(132, 'Fernando ', 'Gutierrez Salinas', 'AF-113', 'fernando@cco.com.mx', 'b30f11370cc0b508bac5a1439e9144dd', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(133, 'Daniela', 'Gutierrez Tapia', 'AF-151', 'daniela@cco.com.mx', '0bdcdc1ed284142dc8e6d20f56290fcc', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(134, 'Jonathan Raul', 'Gutierrez Vazquez', 'AF-226', 'jonathanraul@cco.com.mx', 'baae1114f409d3ca588b3fa2a32f3893', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(135, 'Maria del Carmen ', 'Hernandez Cortes', 'AF-221', 'mariadelcarmen@cco.com.mx', '42065e65dccef4310c98e75376e06ddb', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(136, 'Jurgen Michell ', 'Hernandez Flores', 'AF-119', 'jurgenmichell@cco.com.mx', 'f9188914489a909377e525b7ab79d80c', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(137, 'Mario Antonio ', 'Hernandez Flores', 'AF-104', 'marioantonio@cco.com.mx', '6b12c0fbfaa2dbfa941c83ff4f123b37', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(138, 'Ana Karen ', 'Hernandez Gomez', 'AF-114', 'anakaren@cco.com.mx', '62c952cdc0a1c023e9cd81330b53088e', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(139, 'Edgar', 'Hernandez Lopez', 'AF-164', 'edgar@cco.com.mx', 'bf3b533145516b10fc39dbd28ce312ba', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(140, 'Isaac Armando ', 'Hernandez Lopez', 'AF-107', 'isaacarmando@cco.com.mx', 'e90da4b4ed47e630c455adfbcc50bb90', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(141, 'Fernando', 'Hernandez Maya', '30100', 'fernando@cco.com.mx', '32472eb6885a55919e517965fddd2d74', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(142, 'Jazmin ', 'Hernandez Monter', 'AF-83', 'jazmin@cco.com.mx', 'ae9cd27af3b878183b0553ae8d1c2c50', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(143, 'Israel', 'Huerta Aranda', 'AF-75', 'israel@cco.com.mx', 'd36a008845de227ade36ad1733caf25b', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(144, 'Ismael', 'Iturbe Mendoza', 'AF-162', 'ismael@cco.com.mx', '5be191d2b73a1f2f082022c9699c987f', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(145, 'Kevin Omar', 'Jacuinde Salazar', 'AF-189', 'kevinomar@cco.com.mx', '9160674a60af3003a57b5bbe89a8a057', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(146, 'Marcos ', 'Jaime Lujano', '103', 'marcos.jaime@cco.com.mx', '6974ce5ac660610b44d9b9fed0ff9548', 2, 6, 3, '12135874', '2023-10-09 16:16:22', NULL, NULL, 1),
(147, 'Pedro Angel', 'Jaimes Guzman', 'AF-242', 'pedroangel@cco.com.mx', '8d1ace48db2dc104314f85058f60ff25', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(148, 'Luis Jeronimo', 'Jimenez Garcia', 'AF-23208', 'luisjeronimo@cco.com.mx', '4276779bb2989037e2db87daa2bd5039', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(149, 'Hector', 'Jimenez Ibarra', 'AF-158', 'hector@cco.com.mx', 'a909a0c7f1eee15896fb1719faccf448', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(150, 'Javier ', 'Jimenez Marques', 'AF-215', 'javier@cco.com.mx', '8bc05f5165ea4e0d554c109be141191e', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(151, 'Diana Belem', 'Jimenez Martinez', 'AF-150', 'dianabelem@cco.com.mx', '26efeb627efb722004fde70f2cff3a08', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(152, 'Marcial ', 'Jimenez Rodriguez', 'AF-252', 'marcial@cco.com.mx', '83d745e561ea399dbd85c28b131df12c', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(153, 'Jorge Abraham', 'Jimenez Rojo', 'AF-46', 'jorgeabraham@cco.com.mx', '1a09d6bd2c0c7fc069c6282e9af7f418', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(154, 'Imelda', 'Juarez Cruz', 'AF-22998', 'imelda@cco.com.mx', '10e1869c79e00dee9a26c8203119bb97', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(155, 'Luis Gael', 'Juarez Hernandez', 'AF-24', 'luisgael@cco.com.mx', '0592097c840b72c8807f02b0799e8471', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(156, 'Andres', 'Leyte Manrrique', 'AF-211', 'andres@cco.com.mx', '4d9d5ff690a7a14cdaf49b994c69cc13', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(157, 'Cesar Alexis ', 'Lopez Camacho', 'AF-201', 'cesaralexis@cco.com.mx', '39e6fe0a7c6e40584400db04bb7a8ca7', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(158, 'Cesar Ariel', 'Lopez Camacho', 'AF-203', 'cesarariel@cco.com.mx', '8c83ad7b2c0c8507cfa74aaa654e025f', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(159, 'Agustina', 'Lopez Cruz', 'AF-23035', 'agustina@cco.com.mx', 'c7008ac74f8e5231df09caf72cd6c166', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(160, 'Armando', 'Lopez Gonzalez', 'AF-95', 'armando@cco.com.mx', 'c5fa4e0646576b7e8fcde97ae5943f8b', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(161, 'Jorge Eduardo', 'Lopez Gonzalez', 'AF-192', 'jorgeeduardo@cco.com.mx', '24c76327db873ca686781cd2070c7eb9', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(162, 'Enrique ', 'Lugo Martinez', 'AF-127', 'enrique@cco.com.mx', '368d71b82b1e80bfe94aafd942e572cc', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(163, 'Berenice', 'Luna Allier', 'AF-88', 'berenice@cco.com.mx', '505f20fb4c60d6e15e0735e37c3ab8b6', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(164, 'Laura Angelica ', 'Luna Buendia', 'AF-129', 'lauraangelica@cco.com.mx', '3b7061023ce60dae815275c318eb50bf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(165, 'Nestor Ignacio', 'Macias Luna', 'AF-50', 'nestorignacio@cco.com.mx', '7bd17ac038c2438dac11607d89be51a6', 2, 2, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(166, 'Miguel ', 'Macias Maldonado', 'AF-253', 'miguel@cco.com.mx', 'b2c87812f4da29c81926fb34932b8c22', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(167, 'Omar Eduardo ', 'Macias Oble', 'AF-254', 'omareduardo@cco.com.mx', '369527f0a7580864e840c95fa15c880d', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(168, 'Luis Daniel', 'Magdaleno Baeza', 'AF-34', 'luisdaniel@cco.com.mx', 'b7b3867ffec7e346399f67dde70db326', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(169, 'Jose Raymundo', 'Martinez Alvarez', 'AF-51', 'joseraymundo@cco.com.mx', '73bb2a4c1ebc7aa6074ab928fee5a3ad', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(170, 'Luis Alberto ', 'Martinez Casiano', 'AF-231', 'luisalberto@cco.com.mx', '8fbfd3cbaa7ed355adc8c2a61a9ec03e', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(171, 'Francisco', 'Martinez Gallegos', 'AF-170', 'francisco@cco.com.mx', 'a283c1c182702c354af3ab8f9b75123b', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(172, 'Ricardo ', 'Martinez Gaspar', 'AF-145', 'ricardo@cco.com.mx', '310d1d24adad4f4345a88285e4b4eb97', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(173, 'Jorge Ivan ', 'Martinez Hernandez', 'AF-2420', 'jorgeivan@cco.com.mx', '63eeef35234b959605834a9ad557d8fa', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(174, 'Juan Manuel', 'Martinez Hernandez', 'AF-47', 'juanmanuel@cco.com.mx', '8d427612f7b82eb318209c3233e1b167', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(175, 'Daniel ', 'Martinez Martinez', 'AF-202', 'daniel@cco.com.mx', 'd7edb67e20a538c084de4aecea5fa0e7', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(176, 'Gilberto ', 'Martinez Ortega', 'AF-255', 'gilberto@cco.com.mx', '3fee5ea52198fc701ae61dadd5166bc8', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(177, 'Edwin Emanuel', 'Martinez Sanchez', 'AF-256', 'edwinemanuel@cco.com.mx', '77ac6b3f799e5295543eed6fd7230c8e', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(178, 'Julio Cesar ', 'Martinez Suarez', 'AF-96', 'juliocesar@cco.com.mx', '48cdf5662f8ce5dcc6195307a6cd0bf3', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(179, 'Donovan', 'Medellin Patlan', 'AF-257', 'donovan@cco.com.mx', '46dff9cf313239468a9abb21c3440db9', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(180, 'Miguel Angel', 'Medina Granados', 'AF-154', 'miguelangel@cco.com.mx', '9406d7947306d12c10e88ca13285874b', 3, 14, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(181, 'Carlos ', 'Medina Vega Roberto', 'AF-240', 'carlos@cco.com.mx', '366549901d22b921805a80103562f50e', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(182, 'Angel', 'Mendez Canales', 'AF-141', 'angel@cco.com.mx', 'df49820ba747ee7cbc2a9ef27dbf41b7', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(183, 'Marco Antonio', 'Mendoza Guzman', 'AF-185', 'marcoantonio@cco.com.mx', '7db01c6d3246cab198018f3612e17a94', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(184, 'Ana Rosa ', 'Mendoza Quintero', 'AF-131', 'anarosa@cco.com.mx', 'f20b785befed7dbb18262e8b84566dd6', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(185, 'Irving Francisco', 'Mondragon Mancilla', 'AF-19954', 'irvingfrancisco@cco.com.mx', '4c262a26ffbb76bccb9ec9cbfef79660', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(186, 'Carlos Daniel ', 'Morales Gonzalez', 'AF-205', 'carlosdaniel@cco.com.mx', '9e730153c948c0d1eb0732c5d4ffcf6f', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(187, 'Daniel Humberto', 'Moreno Alcantar', 'AF-76', 'danielhumberto@cco.com.mx', '4475a61f8429cdff655f91b049ea3c62', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(188, 'Hector Alejandro ', 'Moreno Reyna', 'AF-208', 'hectoralejandro@cco.com.mx', '8a695731fd5937b0a46ef85266d5cb5b', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(189, 'Miguel Angel', 'Muñoz Garcia', 'AF-219', 'miguelangel@cco.com.mx', '548f8a34d5452b815552bc1629c25bd8', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(190, 'Jesus Antonio ', 'Nava Anaya', 'AF-213', 'jesusantonio@cco.com.mx', 'b24ca118b9a16aadd9248b4ade8d48f8', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(191, 'Abraham Alejandro', 'Nava Rojas', 'AF-53', 'abrahamalejandro@cco.com.mx', 'c70ce0434b9a2b50d87972da49e28bda', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(192, 'Erick Miguel ', 'Nava Sanchez', 'AF-174', 'erickmiguel@cco.com.mx', '4b8691b612bc7bb78b3caa5145252242', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(193, 'Brenda Nataly', 'Nieto Castañeda', 'AF', 'brendanataly@cco.com.mx', '06fa567b72d78b7e3ea746973fbbd1d5', 2, 2, 3, '1', '2023-10-09 16:16:22', NULL, '2023-10-26 14:00:15', 0),
(194, 'Jose Marcos', 'Nuñez Dominguez', 'AF-59', 'josemarcos@cco.com.mx', '4ff7cf9ba531ea3ed291b6078bcf4f84', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(195, 'Esteban ', 'Olguin Nolasco', 'AF-115', 'esteban@cco.com.mx', 'b6bf6a7c8e7ca78775d557ae4df613c1', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(196, 'Brandon Axel', 'Oliva Robledo', 'AF-135', 'brandonaxel@cco.com.mx', 'e21f3bfe8074f518b4bda7525b96129f', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(197, 'Lesli Yaremi', 'Olvera Rodriguez', 'AF-227', 'lesliyaremi@cco.com.mx', '0229c1a58014ebb20c811e70195130e6', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(198, 'Maria del Rosario', 'Orozco Rosario', 'AF-94', 'mariadelrosario@cco.com.mx', '9862909a117d8eaef6230ba2fa91a341', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(199, 'Luis Alfredo ', 'Ortega Covarrubias', 'AF-183', 'luisalfredo@cco.com.mx', '50f2c16bffab104ff88fb044b1744a4f', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(200, 'Ivan ', 'Ortega Diaz', 'AF-225', 'ivan@cco.com.mx', '18a04e816a9f3e1d40c776069add9d45', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(201, 'Jose Alexei', 'Ortega Molina', 'AF-212', 'josealexei@cco.com.mx', '626c6d65ad69cbb004acd79d4c740ce9', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(202, 'Joaquin ', 'Otañez Cazarez', 'AF-149', 'joaquin@cco.com.mx', '473537275dfaae8e2fc4587dd0f78090', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(203, 'Francisco Efrain', 'Parra Oropeza', 'AF-142', 'franciscoefrain@cco.com.mx', '34251ee5053b67bef71671f68c608742', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(204, 'Itzmatl Damian', 'Peralta Perez', 'AF-05', 'itzmatldamian@cco.com.mx', '83c6e1d198ba59810a3837b395230020', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(205, 'Leonides Francisco ', 'Perez Acleto', 'AF-180', 'leonidesfrancisco@cco.com.mx', '86205b66dfd852f2e5faf8164e9c94ac', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(206, 'Owen Axel ', 'Perez Manzur', 'AF-92', 'owenaxel@cco.com.mx', '057253e8ddfbd49c1403a5568dda8c7e', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(207, 'Julio', 'Perez Orta', 'AF-26', 'julio@cco.com.mx', '319fbcb0940a890c266d670ec83d5246', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(208, 'Miguel Angel', 'Perez Orta', 'AF-12', 'miguelangel@cco.com.mx', '9021a30f647d2bf0224a15cc33dc8a19', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(209, 'Victor Hugo ', 'Perez Padilla', 'AF-234', 'victorhugo@cco.com.mx', 'd28abdcddf70037247541afe030286a7', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(210, 'Gilberto ', 'Perez Ramirez', 'AF-116', 'gilberto@cco.com.mx', '3131cfd8e6e235110a7a3266f7095dc5', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(211, 'Jesus Angel', 'Pineda Arriaga', 'AF-241', 'jesusangel@cco.com.mx', '1c1ecb344e715a26c7183c3adcc2fb15', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(212, 'Yoman Francisco ', 'Piscil Fuentes', 'AF-238', 'yomanfrancisco@cco.com.mx', '216633261e9931581729c29e6e39dd92', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(213, 'Fatima Yoselin', 'Quintero Corona', 'AF-60', 'fatimayoselin@cco.com.mx', '67caf418c9668580b13ad630f74c8d65', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(214, 'Rogelio ', 'Ramiez Torres', 'AF-232', 'rogelio@cco.com.mx', '21744d89f383a59a355718cbc42783f6', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(215, 'Giovanni', 'Ramirez Nava', 'AF-23205', 'giovanni@cco.com.mx', '7792bb6e134edc0c7f370551b7afe18d', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(216, 'Victor Enrique', 'Ramirez Rendon', 'AF-16', 'victorenrique@cco.com.mx', '982544df3f3a59b8210ce999751420f8', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(217, 'Christian Ivan', 'Real Ramirez', 'AF-194', 'christianivan@cco.com.mx', '71194a8157f01e828e3e8adc318f3f72', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(218, 'Juan David', 'Recoba Altamirano', 'AF-198', 'juandavid@cco.com.mx', 'ae96543f7cb6b4a2147972256d1a9413', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(219, 'Arath', 'Rendon Acosta', 'AF-35', 'arath@cco.com.mx', '38b97b87b5a710285b22374ea50c0613', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(220, 'Emory', 'Reyes Martinez', 'AF-62', 'emory@cco.com.mx', '6931987dd5ed9635bbe2cd7ed3d3f497', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(221, 'Jose Manuel', 'Reyes Martinez', 'AF-222', 'josemanuel@cco.com.mx', '7747636666e7a01bfb909826efcba2ee', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(222, 'Edgar ', 'Rios Gonzlez', 'AF-258', 'edgar@cco.com.mx', '5594df958c53e0b46a8bd3a607a4787d', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(223, 'Victor Antonio ', 'Rivera Flores', 'AF-110', 'victorantonio@cco.com.mx', '2ccb13eb1286634bd5681b1d19b628c0', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(224, 'Juan de Dios ', 'Rivera Rodriguez', 'AF-172', 'juandedios@cco.com.mx', 'aa05f214407393028d4e79654f0219b9', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(225, 'Jose Luis', 'Rivera Tellez', 'AF-79', 'joseluis@cco.com.mx', 'c7b3f55b2b7339b7150e3666356a570e', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(226, 'Magali Lucero', 'Rodrigez Garcia', 'AF-56', 'magalilucero@cco.com.mx', '91fde816e968a6674dbee6a239799fe7', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(227, 'Mario Alberto ', 'Rodriguez Cruz', 'AF-117', 'marioalberto@cco.com.mx', 'cc76a9c4eb55dd531bc8bee893b96c30', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(228, 'Bryan ', 'Rodriguez Galvan', 'AF-216', 'bryan@cco.com.mx', '3b6ffdde6e909be34bad0fdfb9328f2f', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(229, 'Miguel Angel ', 'Rodriguez Garcia', 'AF-228', 'miguelangel@cco.com.mx', '50f247ce333c22f2e46609e2d4d46f2e', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(230, 'Arnold', 'Rodriguez Tagano', 'AF-159', 'arnold@cco.com.mx', 'b0558203fb21b1bf58ca0c0c8fdd7161', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(231, 'Christopher Cenorino', 'Rodriguez Tagano', 'AF-163', 'christophercenorino@cco.com.mx', '574025fa8dac31b70a478e095e5d79b7', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(232, 'Juan Carlos', 'Rojas Bautista', 'AF-165', 'juancarlos@cco.com.mx', '9a1285791e7b274631ddf6ef0328154e', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(233, 'Sergio ', 'Rojas Rivera', 'AF-181', 'sergio@cco.com.mx', '3e28cfadd66592726f3219df543acb4e', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(234, 'Concepcion', 'Roque Cruz', 'AF-160', 'concepcion@cco.com.mx', '1c1009060cf44d54b619faac8058a2c3', 3, 14, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(235, 'Ceron Jair David', 'Ruiz Velazco', 'AF-72', 'ceronjairdavid@cco.com.mx', '893ee191128ddb0582f8909c2ec6bfa7', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(236, 'Eduardo', 'Salazar Contreras', 'AF-259', 'eduardo@cco.com.mx', '51f49b9b014e3d567f110b6a8c7ede49', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(237, 'Giron Jovanny', 'Salazar Tellez', 'AF-169', 'gironjovanny@cco.com.mx', '9a69b6187cfe87fb4c7189e88680e48a', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(238, 'Juan Manuel ', 'Salguero Garcia', 'AF-260', 'juanmanuel@cco.com.mx', '4627741f1324eab1ea17f2d8aa94c197', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(239, 'Lorena', 'Salinas Ramirez', 'AF-143', 'lorena@cco.com.mx', '96ffb73413d3bd9a1c207df9eecc86d2', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(240, 'Hernandez Salvador', 'San Juan', 'AF-64', 'hernandezsalvador@cco.com.mx', 'f1ddcf27dc259684bae8360927ea0d7b', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(241, 'Jonathan Israel', 'Sanchez Aguilera', 'AF-19256', 'jonathanisrael@cco.com.mx', 'e0d679c70ba5ae74863d1e6054a93576', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(242, 'Jose Nicolas ', 'Sanchez Chavez', 'AF-220', 'josenicolas@cco.com.mx', '8b2faca07b99c3d56b44a4bd9ac042a1', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(243, 'Johan Mohamed', 'Sanchez Garay', 'AF-171', 'johanmohamed@cco.com.mx', 'b14bdf985b80513b29a8c030adecb354', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(244, 'Veronica ', 'Sanchez Hernandez', 'AF-112', 'veronica@cco.com.mx', '2ac2341bee90ed1baabe3ce3e912f526', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, '2023-11-19 08:36:58', 0),
(245, 'Johan Miguel', 'Sanchez Jorge', 'AF-200', 'johanmiguel@cco.com.mx', '0ea5c95d082806b70ec7f7a731c87d07', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(246, 'Jose Luis', 'Sanchez Vara', 'AF-23109', 'joseluis@cco.com.mx', 'e4bf7d996466a7f74e01aad18e2b037d', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(247, 'Leopoldo', 'Sandoval alvarez', 'AF-23179', 'leopoldo@cco.com.mx', 'd531fe1fcd9471fa0cc6282476eafc3c', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(248, 'David Gerson ', 'Santiago Rodriguez', 'AF-78', 'davidgerson@cco.com.mx', '447c5764848238c3eb5d2e7e83bc8c44', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(249, 'Axel Alfredo', 'Santiago Sanchez', 'AF-49', 'axelalfredo@cco.com.mx', '3744e09b6e8934412472750a860bb2f4', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(250, 'Eva', 'Tellez Lopez', 'AF-152', 'eva@cco.com.mx', '491688e98de0657af771663415ca2855', 3, 14, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(251, 'Victor ', 'Torres Cruz', 'AF-229', 'victor@cco.com.mx', 'c38f457e15fbc7d23b848bd98071b8d4', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(252, 'Juan ', 'Torres Ibarra', 'AF-123', 'juan@cco.com.mx', 'dabe7f8c71b5a4c8f533b6cc9ac22b82', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(253, 'Jorge Osvaldo ', 'Torres Sanchez', 'AF-85', 'jorgeosvaldo@cco.com.mx', 'b25e88245c1a53a6bd0584866e7625e0', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(254, 'Jeronimo ', 'Ugalde Espino', 'AF-214', 'jeronimo@cco.com.mx', '2012f675263a24058bd7d6c3cf39e82b', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(255, 'Axel', 'Uribe Jimenez', 'AF-15', 'axel@cco.com.mx', '5a704e38064d50b8e678181a0c9d3360', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(256, 'Jose Eduardo ', 'Hernandez Vazquez', 'AF-140', 'joseeduardo@cco.com.mx', '9ffb29472ec8f9d41fef43f1dd3deb5e', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(257, 'Jose Francisco ', 'Perez Vallejo', 'AF-118', 'josefrancisco@cco.com.mx', '157076da44450af88035a71263c8d5cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(258, 'Jonathan Alejandro ', 'Reyes Perez', 'AF-121', 'jonathanalejandro@cco.com.mx', 'cf967db99b73b91e5cc8a87421ac245b', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(259, 'Jose Alberto ', 'Trejo Torres', 'AF-270', 'josealberto@cco.com.mx', 'ff98ff161e76e83c4084292faa68fbdc', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(260, 'Victor Hugo', 'Gonzalez Gomez', 'AF-265', 'victorhugo@cco.com.mx', '3f8854ef539b4283fc05d09d9a94053b', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(261, 'Cruz Jesus ', 'Valdez de', 'AF-209', 'cruzjesus@cco.com.mx', 'cacbd12bf4869e8bafce8f2242804cc2', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(262, 'Juan Pablo', 'Valladolid Habana', 'AF-146', 'juanpablo@cco.com.mx', '88ade7fed7bc020560e7afad650ad18b', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(263, 'Jorge Joel ', 'Vargas Acosta', 'AF-261', 'jorgejoel@cco.com.mx', 'c937064a43fa6210693cdd69644f8cbe', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(264, 'Daniel ', 'Vazquez Duran', 'AF-262', 'daniel@cco.com.mx', '11b5e6d119f4a28b3b55fc2baea8fc1d', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(265, 'Eduardo', 'Vazquez Lopez', 'AF-161', 'eduardo@cco.com.mx', '06fd71b6e0e505e8d3a6859ae66aea5c', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(266, 'Ulises Alejandro', 'Vazquez Lopez', 'AF-177', 'ulisesalejandro@cco.com.mx', 'f09f4aa60e97eea0fdf693e0addc9db7', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(267, 'Jacqueline', 'Vega Carrasco', 'SC-20', 'jacqueline@cco.com.mx', '7b6830dd929d899f716d9ee5c664384b', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(268, 'Alfonso', 'Martinez Perez', 'AF-225', 'alfonso@cco.com.mx', '18a04e816a9f3e1d40c776069add9d45', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(269, 'Hugo ', 'Vences Martinez', 'AF-80', 'hugo@cco.com.mx', '6c1160c0c8f2cbd1011b8bc3fe6fbe0e', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(270, 'Mario Alberto', 'Victoria Garcia', 'AF-71', 'marioalberto@cco.com.mx', '5b425a4b46654388b342bb3c07e55a67', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(271, 'Lucio', 'Zarate Lopez', 'AF-243', 'lucio@cco.com.mx', 'b3eb38fca805d6611266659a0651a0c8', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(272, 'Vianey', 'Alcantara Arroniz', 'OR-44', 'vianey@cco.com.mx', 'a7f5c41dc6891ce6e731e73ef77088e6', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(273, 'Julio Cesar', 'Cortes Lopez', 'OR-47', 'juliocesar@cco.com.mx', 'd10dafd1dc1ea97683e1839d8c917f93', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(274, 'Raul Sebastian', 'Hernandez Granados', 'OR-50', 'raulsebastian@cco.com.mx', 'febc51470c4e77fb5aa3a903a277aa99', 3, 3, 1, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(275, 'Joshua', 'Duran Amezcua', 'M-21', 'joshua@cco.com.mx', 'b0d2a4e4d0a5aaacf9e8053eb869469d', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(276, 'Ramon', 'Espitia Martinez', 'M-20971', 'ramon@cco.com.mx', '894795044f46b815630ca34a263136ed', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(277, 'Brenda Riccel', 'Flores Alcantara', 'M-2404', 'brendariccel@cco.com.mx', '459bc0354a7b4dd5c0c742065ed54f6b', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(278, 'Jesus Alejandro ', 'Garcia Huerta', 'M-02', 'jesusalejandro@cco.com.mx', 'b9bfb8d8e145c544941b2bcb27be1575', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(279, 'Juan Manuel', 'Hernandez Martinez', 'M-2413', 'juanmanuel@cco.com.mx', '0b52071d61f4ae15f0e30e74832c72d8', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(280, 'Reyes ', 'Lopez Lardizabal', 'M-2417', 'reyes@cco.com.mx', 'c0a4aa216d81914688d1fd4a9080ea4e', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(281, 'Christian Jibran', 'Rodriguez Ramirez', 'M-15', 'christianjibran@cco.com.mx', '9e2b4f0f27db6dc6400b9b3c931d0ded', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(282, 'Erick', 'Santos Victoria', 'M-21027', 'erick@cco.com.mx', '850550aecf2513bda19b4a24bf4e6064', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(283, 'Erick Uriel', 'Zepeda Flores', 'M-15978', 'erickuriel@cco.com.mx', '38b0a721b7fb0bc8f778c8ce761ef698', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(284, 'Haydee', 'Ortiz', '1574', 'auxsist5_solulogis@outlook.com', '0d4f4805c36dc6853edfa4c7e1638b48', 1, 1, 1, '9982421738', '2023-10-10 12:06:45', NULL, NULL, 1),
(285, 'Gamaliel', 'Amaro', '12345', 'gamaliel.amaro@solulogis.net', '827ccb0eea8a706c4c34a16891f84e7b', 1, 1, 3, '018009998080', '2023-10-11 08:42:30', NULL, NULL, 1),
(286, 'Chrysthian Isaury', 'Hernández', '1234', 'chrysthian@cco.com.mx', '81dc9bdb52d04dc20036dbd8313ed055', 2, 2, 3, '5512345678', '2023-10-16 12:51:19', NULL, NULL, 1),
(287, 'Cesar', 'Padilla', '366047', 'cesar@cco.com.mx', '698c5816a425026ce39a9077192c7bf5', 2, 2, 2, '5512345678', '2023-10-16 15:59:13', NULL, NULL, 1),
(290, 'Julio Cesar', 'Baez', '7676', 'julio@cco.com.mx', 'cfe8504bda37b575c70ee1a8276f3486', 2, 2, 3, '1', '2023-10-18 15:27:19', NULL, NULL, 1),
(291, 'Brain Luna', 'Guzmán', '6363', 'brain@cco.com.mx', '075b051ec3d22dac7b33f788da631fd4', 2, 2, 3, '1', '2023-10-18 15:54:31', NULL, NULL, 1),
(292, 'Brenda Joceline', 'Gutiérrez Tranquilino', '8990', 'brendajoceline@cco.com.mx', 'ce65f40e3a20ad19fe352c52ce3bcf51', 2, 2, 3, '1', '2023-10-23 18:15:51', NULL, NULL, 1),
(293, 'Itzel', 'Hernández Tejeda', 'AF-63', 'itzel.hernandez@cco.com.mx', '87e4f13aa590cf093bab8ff4391c8e82', 2, 6, 3, '5544882881', '2023-10-26 10:43:25', NULL, '2023-10-26 14:03:24', 1),
(294, 'prueba', 'asdf', '123456', 'prueba@gmail.com', 'e10adc3949ba59abbe56e057f20f883e', 2, 4, 3, '1', '2023-10-26 14:51:34', NULL, '2023-10-26 14:52:00', 0),
(295, 'Emmanuel', 'Martínez Romo', '4554', 'emmanuel@cco.com.mx', 'e7023ba77a45f7e84c5ee8a28dd63585', 2, 6, 3, '1', '2023-10-27 14:10:12', NULL, NULL, 1),
(297, 'Mariana Alejandra ', 'Feria Mendoza', '101', 'administracion-2@cco.com.mx', '38b3eff8baf56627478ec76a704e9b52', 2, 6, 3, '5530643155', '2023-11-18 12:11:13', NULL, NULL, 1),
(298, 'Francisco Javier', 'Moreno Guerrero', '7898', 'franciscojavier@cco.com.mx', '0e080857e96278e6dba76ac029faf291', 2, 6, 3, '1', '2023-11-19 08:48:22', NULL, NULL, 1),
(299, 'Miguel ', 'Maceda', '102', 'miguel.maceda@cco.com.mx', 'ec8956637a99787bd197eacd77acce5e', 2, 6, 3, '12345689', '2023-11-24 10:54:31', NULL, NULL, 1),
(300, 'Jibran', 'Rodriguez Ramirez', '104', 'jibran@cco.com.mx', 'c9e1074f5b3f9fc8ea15d152add07294', 2, 4, 3, '12587496', '2023-12-27 09:16:04', NULL, NULL, 1),
(301, 'Paola', 'Valencia', '2056', 'implementacion1@solulogis.com', 'a96d3afec184766bfeca7a9f989fc7e7', 1, 17, 3, '9851153386', '2023-12-28 12:33:04', NULL, NULL, 1),
(302, 'Gabriela', 'Canul', '2059', 'implementacion2@solulogis.com', '2eace51d8f796d04991c831a07059758', 1, 17, 3, '9992622156', '2023-12-28 12:37:51', NULL, NULL, 1),
(303, 'Jairo', 'Vazquez', '1765', 'implementacion4@solulogis.com', '8698ff92115213ab187d31d4ee5da8ea', 1, 17, 3, '2491464739', '2023-12-28 12:43:30', NULL, NULL, 1),
(304, 'Sandra', 'Zarate', '145', 'sandra.zarate@solulogis.com', '2b24d495052a8ce66358eb576b8912c8', 1, 17, 1, '5569680887', '2023-12-28 15:07:13', NULL, NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `td_documento`
--
ALTER TABLE `td_documento`
  ADD PRIMARY KEY (`doc_id`);

--
-- Indices de la tabla `td_documento_detalle`
--
ALTER TABLE `td_documento_detalle`
  ADD PRIMARY KEY (`det_id`);

--
-- Indices de la tabla `td_documento_tarea`
--
ALTER TABLE `td_documento_tarea`
  ADD PRIMARY KEY (`id_documento_tarea`),
  ADD KEY `fk_id_tarea_documento` (`id_tarea`);

--
-- Indices de la tabla `td_documento_tarea_detalle`
--
ALTER TABLE `td_documento_tarea_detalle`
  ADD PRIMARY KEY (`id_tarea_detalle`),
  ADD KEY `fk_id_tarea_detalle` (`id_tarea`);

--
-- Indices de la tabla `td_pausas_ticket`
--
ALTER TABLE `td_pausas_ticket`
  ADD PRIMARY KEY (`pausas_ticket_id`),
  ADD KEY `fk_id_ticket` (`id_ticket`),
  ADD KEY `fk_id_usuario_en_pausas_ticket` (`id_usuario`);

--
-- Indices de la tabla `td_tareadetalle`
--
ALTER TABLE `td_tareadetalle`
  ADD PRIMARY KEY (`tareadetalle_id`),
  ADD KEY `fk_tarea_id` (`tarea_id`),
  ADD KEY `fk_usu_id` (`usu_id`);

--
-- Indices de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  ADD PRIMARY KEY (`tickd_id`);

--
-- Indices de la tabla `tm_almacen`
--
ALTER TABLE `tm_almacen`
  ADD PRIMARY KEY (`id_almacen`);

--
-- Indices de la tabla `tm_area_almacen`
--
ALTER TABLE `tm_area_almacen`
  ADD PRIMARY KEY (`id_area_almacen`),
  ADD KEY `fk_id_almacen` (`id_almacen`);

--
-- Indices de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indices de la tabla `tm_notificacion`
--
ALTER TABLE `tm_notificacion`
  ADD PRIMARY KEY (`not_id`);

--
-- Indices de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  ADD PRIMARY KEY (`prio_id`);

--
-- Indices de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  ADD PRIMARY KEY (`cats_id`);

--
-- Indices de la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  ADD PRIMARY KEY (`id_tarea`),
  ADD KEY `id_ticket` (`id_ticket`),
  ADD KEY `fk_id_usuario` (`id_usuario`);

--
-- Indices de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  ADD PRIMARY KEY (`tick_id`),
  ADD KEY `fk_usu_id2` (`usu_id`);

--
-- Indices de la tabla `tm_usr_cat`
--
ALTER TABLE `tm_usr_cat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usu_id` (`usu_id`,`rol_id`,`cat_id`),
  ADD KEY `cat_id` (`cat_id`),
  ADD KEY `rol_id` (`rol_id`);

--
-- Indices de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  ADD PRIMARY KEY (`usu_id`),
  ADD KEY `fk_id_almacen_usuario` (`usu_almacen`),
  ADD KEY `fk_id_area_usuario` (`usu_area`),
  ADD KEY `rol_id` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `td_documento`
--
ALTER TABLE `td_documento`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_documento_detalle`
--
ALTER TABLE `td_documento_detalle`
  MODIFY `det_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_documento_tarea`
--
ALTER TABLE `td_documento_tarea`
  MODIFY `id_documento_tarea` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_documento_tarea_detalle`
--
ALTER TABLE `td_documento_tarea_detalle`
  MODIFY `id_tarea_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_pausas_ticket`
--
ALTER TABLE `td_pausas_ticket`
  MODIFY `pausas_ticket_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_tareadetalle`
--
ALTER TABLE `td_tareadetalle`
  MODIFY `tareadetalle_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  MODIFY `tickd_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_almacen`
--
ALTER TABLE `tm_almacen`
  MODIFY `id_almacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tm_area_almacen`
--
ALTER TABLE `tm_area_almacen`
  MODIFY `id_area_almacen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `tm_notificacion`
--
ALTER TABLE `tm_notificacion`
  MODIFY `not_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  MODIFY `prio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  MODIFY `cats_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT de la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  MODIFY `id_tarea` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  MODIFY `tick_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_usr_cat`
--
ALTER TABLE `tm_usr_cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=305;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `td_documento_tarea`
--
ALTER TABLE `td_documento_tarea`
  ADD CONSTRAINT `fk_id_tarea_documento` FOREIGN KEY (`id_tarea`) REFERENCES `tm_tarea` (`id_tarea`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `td_documento_tarea_detalle`
--
ALTER TABLE `td_documento_tarea_detalle`
  ADD CONSTRAINT `fk_id_tarea_detalle` FOREIGN KEY (`id_tarea`) REFERENCES `td_tareadetalle` (`tareadetalle_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `td_pausas_ticket`
--
ALTER TABLE `td_pausas_ticket`
  ADD CONSTRAINT `fk_id_ticket` FOREIGN KEY (`id_ticket`) REFERENCES `tm_ticket` (`tick_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_usuario_en_pausas_ticket` FOREIGN KEY (`id_usuario`) REFERENCES `tm_usuario` (`usu_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `td_tareadetalle`
--
ALTER TABLE `td_tareadetalle`
  ADD CONSTRAINT `fk_tarea_id` FOREIGN KEY (`tarea_id`) REFERENCES `tm_tarea` (`id_tarea`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usu_id` FOREIGN KEY (`usu_id`) REFERENCES `tm_usuario` (`usu_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tm_area_almacen`
--
ALTER TABLE `tm_area_almacen`
  ADD CONSTRAINT `fk_id_almacen` FOREIGN KEY (`id_almacen`) REFERENCES `tm_almacen` (`id_almacen`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  ADD CONSTRAINT `fk_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `tm_usuario` (`usu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tm_tarea_ibfk_1` FOREIGN KEY (`id_ticket`) REFERENCES `tm_ticket` (`tick_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  ADD CONSTRAINT `fk_usu_id2` FOREIGN KEY (`usu_id`) REFERENCES `tm_usuario` (`usu_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tm_usr_cat`
--
ALTER TABLE `tm_usr_cat`
  ADD CONSTRAINT `tm_usr_cat_ibfk_1` FOREIGN KEY (`usu_id`) REFERENCES `tm_usuario` (`usu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tm_usr_cat_ibfk_3` FOREIGN KEY (`rol_id`) REFERENCES `tm_usuario` (`rol_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  ADD CONSTRAINT `fk_id_almacen_usuario` FOREIGN KEY (`usu_almacen`) REFERENCES `tm_almacen` (`id_almacen`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_area_usuario` FOREIGN KEY (`usu_area`) REFERENCES `tm_area_almacen` (`id_area_almacen`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
