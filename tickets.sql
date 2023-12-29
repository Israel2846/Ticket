-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-12-2023 a las 02:56:54
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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`sol114`@`localhost` PROCEDURE `filtrar_ticket` (IN `tick_titulo` VARCHAR(50), IN `cat_id` INT, IN `prio_id` INT)   BEGIN
 IF tick_titulo = '' THEN            
 SET tick_titulo = NULL;
 END IF; 
 IF cat_id = '' THEN            
 SET cat_id = NULL;
 END IF; 
 IF prio_id = '' THEN  
 SET prio_id = NULL;
 END IF;
SELECT
tm_ticket.tick_id,
tm_ticket.usu_id,
tm_ticket.cat_id,
tm_ticket.tick_titulo,
tm_ticket.tick_descrip,
tm_ticket.tick_estado,
tm_ticket.fech_crea,
tm_ticket.fech_cierre,
tm_ticket.usu_asig,
tm_ticket.fech_asig,
tm_usuario.usu_nom,
tm_usuario.usu_ape,
tm_categoria.cat_nom,
tm_ticket.prio_id,
tm_prioridad.prio_nom,
CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_crea, tm_ticket.fech_asig), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_crea, tm_ticket.fech_asig)%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_crea, tm_ticket.fech_asig)%60, ' minutos') AS timeresp,
CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_crea, NOW()), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_crea, NOW())%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_crea, NOW())%60, ' minutos') AS timetransc,
CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_asig, tm_ticket.fech_cierre), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_asig, tm_ticket.fech_cierre)%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_asig, tm_ticket.fech_cierre)%60, ' minutos') AS timetarea,
CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_crea, tm_ticket.fech_cierre), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_crea, tm_ticket.fech_cierre)%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_crea, tm_ticket.fech_cierre)%60, ' minutos') AS tiempototal
FROM
tm_ticket
INNER join tm_categoria on tm_ticket.cat_id = tm_categoria.cat_id
INNER join tm_usuario on tm_ticket.usu_id = tm_usuario.usu_id
INNER join tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
WHERE
tm_ticket.est = 1 and tm_ticket.tick_estado = 'Abierto'
AND tm_ticket.tick_titulo like IFNULL(tick_titulo,tm_ticket.tick_titulo)
AND tm_ticket.cat_id =  IFNULL(cat_id,tm_ticket.cat_id)
AND tm_ticket.prio_id = IFNULL(prio_id,tm_ticket.prio_id);
END$$

CREATE DEFINER=`sol114`@`localhost` PROCEDURE `filtrar_ticket2` (IN `tick_titulo` VARCHAR(50), IN `cat_id` INT, IN `prio_id` INT)   SELECT 
            tm_ticket.tick_id, 
            tm_ticket.usu_id,
            tm_ticket.cat_id,
            tm_ticket.tick_titulo, 
            tm_ticket.tick_descrip,
            tm_ticket.tick_estado, 
            tm_ticket.fech_crea, 
            tm_ticket.fech_cierre, 
            tm_ticket.usu_asig, 
            tm_ticket.fech_asig, 
            tm_usuario.usu_nom, 
            tm_usuario.usu_ape, 
            tm_categoria.cat_nom, 
            tm_ticket.prio_id, 
            tm_prioridad.prio_nom 
            FROM 
            tm_ticket 
            INNER join tm_categoria on tm_ticket.cat_id=tm_categoria.cat_id 
            INNER join tm_usuario on tm_ticket.usu_id=tm_usuario.usu_id 
            INNER join tm_prioridad on tm_ticket.prio_id=tm_prioridad.prio_id 
            WHERE 
            tm_ticket.est = 1 
            AND tm_ticket.tick_titulo like IFNULL(tick_titulo, tm_ticket.tick_titulo) 
            AND tm_ticket.cat_id like IFNULL(cat_id, tm_ticket.cat_id) 
            AND tm_ticket.prio_id like IFNULL(prio_id, tm_ticket.prio_id)$$

CREATE DEFINER=`sol114`@`localhost` PROCEDURE `sp_d_usuario_01` (IN `xusu_id` INT)   BEGIN
	UPDATE tm_usuario 
	SET 
		est='0',
		fech_elim = now() 
	where usu_id=xusu_id;
END$$

CREATE DEFINER=`sol114`@`localhost` PROCEDURE `sp_i_ticketdetalle_01` (IN `xtick_id` INT, IN `xusu_id` INT)   BEGIN
	INSERT INTO td_ticketdetalle 
    (tickd_id,tick_id,usu_id,tickd_descrip,fech_crea,est) 
    VALUES 
    (NULL,xtick_id,xusu_id,'Ticket Cerrado...',now(),'1');
END$$

CREATE DEFINER=`sol114`@`localhost` PROCEDURE `sp_l_reporte_01` ()   BEGIN
SELECT
	tick.tick_id as id,
	tick.tick_titulo as titulo,
	tick.tick_descrip as descripcion,
	tick.tick_estado as estado,
	tick.fech_crea as FechaCreacion,
	tick.fech_cierre as FechaCierre,
	tick.fech_asig as FechaAsignacion,
	CONCAT(usucrea.usu_nom,' ',usucrea.usu_ape) as NombreUsuario,
	IFNULL(CONCAT(usuasig.usu_nom,' ',usuasig.usu_ape),'SinAsignar') as NombreSoporte,
	cat.cat_nom as Categoria,
	prio.prio_nom as Prioridad,
	sub.cats_nom as SubCategoria
	FROM 
	tm_ticket tick
	INNER join tm_categoria cat on tick.cat_id = cat.cat_id
	INNER JOIN tm_subcategoria sub on tick.cats_id = sub.cats_id
	INNER join tm_usuario usucrea on tick.usu_id = usucrea.usu_id
	LEFT JOIN tm_usuario usuasig on tick.usu_asig = usuasig.usu_id
	INNER join tm_prioridad prio on tick.prio_id = prio.prio_id
	WHERE
	tick.est = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_01` ()   BEGIN
	SELECT * FROM tm_usuario
        INNER JOIN tm_almacen ON 
        tm_usuario.usu_almacen = 
        tm_almacen.id_almacen
        INNER JOIN tm_area_almacen ON 
        tm_usuario.usu_area = 
        tm_area_almacen.id_area_almacen
        where tm_usuario.est = 1;
END$$

CREATE DEFINER=`sol114`@`localhost` PROCEDURE `sp_l_usuario_02` (IN `xusu_id` INT)   BEGIN
	SELECT * FROM tm_usuario where usu_id=xusu_id;
END$$

DELIMITER ;

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

--
-- Volcado de datos para la tabla `td_documento`
--

INSERT INTO `td_documento` (`doc_id`, `tick_id`, `doc_nom`, `fech_crea`, `est`) VALUES
(1, 1, 'ANYDESK.xlsx', '2023-12-28 16:11:56', 1);

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

--
-- Volcado de datos para la tabla `td_pausas_ticket`
--

INSERT INTO `td_pausas_ticket` (`pausas_ticket_id`, `id_usuario`, `id_ticket`, `fecha_pausa`, `fecha_reanuda`) VALUES
(1, 3, 1, '2023-12-28 19:20:57', NULL),
(2, 3, 2, '2023-12-28 19:21:07', NULL),
(3, 3, 3, '2023-12-28 19:21:17', NULL);

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

--
-- Volcado de datos para la tabla `tm_notificacion`
--

INSERT INTO `tm_notificacion` (`not_id`, `usu_id`, `not_mensaje`, `tick_id`, `est`) VALUES
(1, 3, 'Se le ha asignado el ticket Nro : ', 1, 1),
(2, 305, 'Se le ha asignado el ticket Nro : ', 3, 1),
(3, 4, 'Se le ha asignado el ticket Nro : ', 2, 1);

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
(81, 1, 'Antenas', 1),
(82, 14, 'intelisis', 1);

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

--
-- Volcado de datos para la tabla `tm_ticket`
--

INSERT INTO `tm_ticket` (`tick_id`, `usu_id`, `cat_id`, `cats_id`, `tick_titulo`, `tick_descrip`, `tick_estado`, `fech_crea`, `usu_asig`, `fech_asig`, `tick_estre`, `tick_coment`, `fech_cierre`, `prio_id`, `est`) VALUES
(1, 3, 6, 11, 'CAMBIO DE PESO', '<p>Ticket de SCAF</p>', 'Cerrado', '2023-12-28 16:11:56', 3, '2023-12-28 16:15:35', NULL, NULL, '2023-12-28 19:25:48', 2, 1),
(2, 3, 6, 11, 'CAMBIO DE PESO', '<p>SCAF 2</p>', 'Cerrado', '2023-12-28 17:23:31', 4, '2023-12-28 18:57:21', NULL, NULL, '2023-12-28 19:27:01', 2, 1),
(3, 3, 14, 82, 'CAMBIO DE PESO', '<p>asdf</p>', 'Cerrado', '2023-12-28 18:28:12', 305, '2023-12-28 18:37:35', NULL, NULL, '2023-12-28 19:28:29', 1, 1);

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

--
-- Volcado de datos para la tabla `tm_usr_cat`
--

INSERT INTO `tm_usr_cat` (`id`, `usu_id`, `rol_id`, `cat_id`) VALUES
(1, 1, 2, 0),
(2, 2, 2, 0),
(3, 3, 2, 0),
(4, 4, 2, 0),
(5, 5, 3, 0),
(6, 6, 3, 0),
(7, 7, 2, 0),
(8, 8, 3, 0),
(9, 9, 2, 0),
(10, 11, 1, 0),
(11, 12, 2, 0),
(12, 13, 3, 0),
(13, 14, 3, 0),
(14, 15, 3, 0),
(15, 16, 3, 0),
(16, 17, 3, 0),
(17, 18, 3, 0),
(18, 19, 3, 0),
(19, 20, 3, 0),
(20, 21, 3, 0),
(21, 22, 3, 0),
(22, 23, 3, 0),
(23, 24, 3, 0),
(24, 25, 3, 0),
(25, 26, 3, 0),
(26, 27, 3, 0),
(27, 28, 3, 0),
(28, 29, 3, 0),
(29, 30, 3, 0),
(30, 31, 3, 0),
(31, 32, 3, 0),
(32, 33, 3, 0),
(33, 34, 3, 0),
(34, 35, 3, 0),
(35, 36, 3, 0),
(36, 37, 3, 0),
(37, 38, 3, 0),
(38, 39, 3, 0),
(39, 40, 3, 0),
(40, 41, 3, 0),
(41, 42, 3, 0),
(42, 43, 3, 0),
(43, 44, 3, 0),
(44, 45, 3, 0),
(45, 46, 3, 0),
(46, 47, 3, 0),
(47, 48, 3, 0),
(48, 49, 3, 0),
(49, 50, 3, 0),
(50, 51, 3, 0),
(51, 52, 3, 0),
(52, 53, 3, 0),
(53, 54, 3, 0),
(54, 55, 3, 0),
(55, 56, 3, 0),
(56, 57, 3, 0),
(57, 58, 3, 0),
(58, 59, 3, 0),
(59, 60, 3, 0),
(60, 61, 3, 0),
(61, 62, 3, 0),
(62, 63, 3, 0),
(63, 64, 3, 0),
(64, 65, 3, 0),
(65, 66, 3, 0),
(66, 67, 3, 0),
(67, 68, 3, 0),
(68, 69, 3, 0),
(69, 70, 3, 0),
(70, 71, 3, 0),
(71, 72, 3, 0),
(72, 73, 3, 0),
(73, 74, 3, 0),
(74, 75, 3, 0),
(75, 76, 3, 0),
(76, 77, 3, 0),
(77, 78, 3, 0),
(78, 79, 3, 0),
(79, 80, 3, 0),
(80, 81, 3, 0),
(81, 82, 3, 0),
(82, 83, 3, 0),
(83, 84, 3, 0),
(84, 85, 3, 0),
(85, 86, 3, 0),
(86, 87, 3, 0),
(87, 88, 3, 0),
(88, 89, 3, 0),
(89, 90, 3, 0),
(90, 91, 3, 0),
(91, 92, 3, 0),
(92, 93, 3, 0),
(93, 94, 3, 0),
(94, 95, 3, 0),
(95, 96, 3, 0),
(96, 97, 3, 0),
(97, 98, 3, 0),
(98, 99, 3, 0),
(99, 100, 3, 0),
(100, 101, 3, 0),
(101, 102, 3, 0),
(102, 103, 3, 0),
(103, 104, 3, 0),
(104, 105, 3, 0),
(105, 106, 3, 0),
(106, 107, 3, 0),
(107, 108, 3, 0),
(108, 109, 3, 0),
(109, 110, 3, 0),
(110, 111, 3, 0),
(111, 112, 3, 0),
(112, 113, 3, 0),
(113, 114, 3, 0),
(114, 115, 3, 0),
(115, 116, 3, 0),
(116, 117, 3, 0),
(117, 118, 3, 0),
(118, 119, 3, 0),
(119, 120, 3, 0),
(120, 121, 3, 0),
(121, 122, 3, 0),
(122, 123, 3, 0),
(123, 124, 3, 0),
(124, 125, 3, 0),
(125, 126, 3, 0),
(126, 127, 3, 0),
(127, 128, 3, 0),
(128, 129, 3, 0),
(129, 130, 3, 0),
(130, 131, 3, 0),
(131, 132, 3, 0),
(132, 133, 3, 0),
(133, 134, 3, 0),
(134, 135, 3, 0),
(135, 136, 3, 0),
(136, 137, 3, 0),
(137, 138, 3, 0),
(138, 139, 3, 0),
(139, 140, 3, 0),
(140, 141, 3, 0),
(141, 142, 3, 0),
(142, 143, 3, 0),
(143, 144, 3, 0),
(144, 145, 3, 0),
(145, 146, 3, 0),
(146, 147, 3, 0),
(147, 148, 3, 0),
(148, 149, 3, 0),
(149, 150, 3, 0),
(150, 151, 3, 0),
(151, 152, 3, 0),
(152, 153, 3, 0),
(153, 154, 3, 0),
(154, 155, 3, 0),
(155, 156, 3, 0),
(156, 157, 3, 0),
(157, 158, 3, 0),
(158, 159, 3, 0),
(159, 160, 3, 0),
(160, 161, 3, 0),
(161, 162, 3, 0),
(162, 163, 3, 0),
(163, 164, 3, 0),
(164, 165, 3, 0),
(165, 166, 3, 0),
(166, 167, 3, 0),
(167, 168, 3, 0),
(168, 169, 3, 0),
(169, 170, 3, 0),
(170, 171, 3, 0),
(171, 172, 3, 0),
(172, 173, 3, 0),
(173, 174, 3, 0),
(174, 175, 3, 0),
(175, 176, 3, 0),
(176, 177, 3, 0),
(177, 178, 3, 0),
(178, 179, 3, 0),
(179, 180, 3, 0),
(180, 181, 3, 0),
(181, 182, 3, 0),
(182, 183, 3, 0),
(183, 184, 3, 0),
(184, 185, 3, 0),
(185, 186, 3, 0),
(186, 187, 3, 0),
(187, 188, 3, 0),
(188, 189, 3, 0),
(189, 190, 3, 0),
(190, 191, 3, 0),
(191, 192, 3, 0),
(192, 193, 3, 0),
(193, 194, 3, 0),
(194, 195, 3, 0),
(195, 196, 3, 0),
(196, 197, 3, 0),
(197, 198, 3, 0),
(198, 199, 3, 0),
(199, 200, 3, 0),
(200, 201, 3, 0),
(201, 202, 3, 0),
(202, 203, 3, 0),
(203, 204, 3, 0),
(204, 205, 3, 0),
(205, 206, 3, 0),
(206, 207, 3, 0),
(207, 208, 3, 0),
(208, 209, 3, 0),
(209, 210, 3, 0),
(210, 211, 3, 0),
(211, 212, 3, 0),
(212, 213, 3, 0),
(213, 214, 3, 0),
(214, 215, 3, 0),
(215, 216, 3, 0),
(216, 217, 3, 0),
(217, 218, 3, 0),
(218, 219, 3, 0),
(219, 220, 3, 0),
(220, 221, 3, 0),
(221, 222, 3, 0),
(222, 223, 3, 0),
(223, 224, 3, 0),
(224, 225, 3, 0),
(225, 226, 3, 0),
(226, 227, 3, 0),
(227, 228, 3, 0),
(228, 229, 3, 0),
(229, 230, 3, 0),
(230, 231, 3, 0),
(231, 232, 3, 0),
(232, 233, 3, 0),
(233, 234, 3, 0),
(234, 235, 3, 0),
(235, 236, 3, 0),
(236, 237, 3, 0),
(237, 238, 3, 0),
(238, 239, 3, 0),
(239, 240, 3, 0),
(240, 241, 3, 0),
(241, 242, 3, 0),
(242, 243, 3, 0),
(243, 244, 3, 0),
(244, 245, 3, 0),
(245, 246, 3, 0),
(246, 247, 3, 0),
(247, 248, 3, 0),
(248, 249, 3, 0),
(249, 250, 3, 0),
(250, 251, 3, 0),
(251, 252, 3, 0),
(252, 253, 3, 0),
(253, 254, 3, 0),
(254, 255, 3, 0),
(255, 256, 3, 0),
(256, 257, 3, 0),
(257, 258, 3, 0),
(258, 259, 3, 0),
(259, 260, 3, 0),
(260, 261, 3, 0),
(261, 262, 3, 0),
(262, 263, 3, 0),
(263, 264, 3, 0),
(264, 265, 3, 0),
(265, 266, 3, 0),
(266, 267, 3, 0),
(267, 268, 3, 0),
(268, 269, 3, 0),
(269, 270, 3, 0),
(270, 271, 3, 0),
(271, 272, 3, 0),
(272, 273, 3, 0),
(273, 274, 1, 0),
(274, 275, 3, 0),
(275, 276, 3, 0),
(276, 277, 3, 0),
(277, 278, 3, 0),
(278, 279, 3, 0),
(279, 280, 3, 0),
(280, 281, 3, 0),
(281, 282, 3, 0),
(282, 283, 3, 0),
(283, 284, 1, 0),
(284, 285, 3, 0),
(285, 286, 3, 0),
(286, 287, 2, 0),
(287, 290, 3, 0),
(288, 291, 3, 0),
(289, 292, 3, 0),
(290, 293, 3, 0),
(291, 294, 3, 0),
(292, 295, 3, 0),
(293, 297, 3, 0),
(294, 298, 3, 0),
(295, 299, 3, 0),
(296, 300, 3, 0),
(297, 301, 3, 0),
(298, 302, 3, 0),
(299, 303, 3, 0),
(300, 304, 1, 17),
(301, 305, 2, 14);

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
(1, 'Jorge', 'Gala', '1440', 'soporteit@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 1, 2, '9981265517', '2023-10-02 12:01:52', '2023-10-02 12:02:08', NULL, 1),
(2, 'Héctor', 'González', '1797', 'aux-sist4@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 1, 2, '9981265863', '2023-10-02 11:04:15', NULL, NULL, 1),
(3, 'Israel', 'Colin', '2846', 'aux-sist-aifa1@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 2, '5517600294', '2023-10-02 11:15:45', NULL, NULL, 1),
(4, 'Arby', 'Pat', '0088', 'arby.pat@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 1, 2, '9982424145', '2023-10-02 11:23:32', NULL, NULL, 1),
(5, 'Gabriel', 'Mellado', '12345', 'gmellado@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 3, 3, '5512345678', '2023-10-06 12:39:12', NULL, NULL, 1),
(6, 'Mildreth', 'Ponciano', '77', 'mildreth.ponciano@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '5566316591', '2023-10-06 14:19:50', NULL, NULL, 1),
(7, 'Jocelin', 'Galván', '66', 'aux-sist-aifa2@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 2, '5512345678', '2023-10-06 15:00:38', NULL, NULL, 1),
(8, 'Christopher ', 'Durán', 'AF-144', 'cristopher.duran@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '5586161310', '2023-10-06 17:31:40', NULL, NULL, 1),
(9, 'Diego', 'Rosas', '12345', 'aux-sist-aicm2@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 3, 2, '5546968170', '2023-10-09 14:12:35', NULL, NULL, 1),
(11, 'Fernanda', 'Lopez', '12345', 'aux-sist-aicm1@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 3, 1, '5546968170', '2023-10-09 14:15:31', NULL, NULL, 1),
(12, 'Rodrigo', 'Amaro', '1759', 'aux-sist1@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 1, 2, '018009998080', '2023-10-09 14:36:09', NULL, NULL, 1),
(13, 'Jesus Francisco', 'Acuautla Sanchez', 'SC-42', 'jesusfrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(14, ' Alejandro ', 'Arango Gabriel', 'SC-48', 'alejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(15, 'Gian Aldrick', 'Arguelles Franco', 'SC-27', 'gianaldrick@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(16, 'Cecilia', 'Arzate Diaz', 'SC-29', 'cecilia@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 9, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(17, 'Blanca Yanet', 'Barroso Castro', 'SC-52', 'blancayanet@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(18, 'Jose Alfredo', 'Becerril Marquez', 'SC-45', 'josealfredo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(19, 'Abiram Shibolet', 'Bravo Miranda', 'SC-24', 'abiramshibolet@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(20, 'Erick Martin', 'Caballero Ramirez', 'SC-03', 'erickmartin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(21, 'Cynthia Daniela', 'Caseres Lara', 'SC-19', 'cynthiadaniela@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(22, 'Gabriela Abigail', 'Castillo Castillo', 'SC-13', 'gabrielaabigail@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(23, 'Alvaro Adrian', 'Castro Arellano', 'SC-10', 'alvaroadrian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(24, 'Brandon Cristopher', 'Cedillo Rodriguez', 'SC-53', 'brandoncristopher@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(25, 'Hector Miguel', 'Corona Rendon', 'SC-35', 'hectormiguel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(26, 'Jose Manuel', 'Cortes Vazquez', 'SC-04', 'josemanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(27, 'Miguel Angel', 'Cruz Ferreira', 'SC-25', 'miguelangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(28, 'Karla Ximena', 'Diaz Salas', 'SC-50', 'karlaximena@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(29, 'Jesus', 'Dorado Hernandez', 'SC-32', 'jesus@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(30, 'Luis Edwin', 'Galindo Ramirez', 'SC-05', 'luisedwin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(31, 'Ailyn Daniela ', 'Gutierrez Garcia', 'SC-39', 'ailyndaniela@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(32, 'Jose Ricardo', 'Gutierrez Sanchez', 'SC-06', 'josericardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(33, 'Alexis ', 'Hernandez Perez', 'SC-33', 'alexis@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(34, 'Brandon Antonio', 'Martinez Garcia', 'SC-11', 'brandonantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(35, 'Oscar ', 'Martinez Valadez', 'SC-46', 'oscar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 9, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(36, 'Gabriel Alejandro', 'Mellado Martinez', 'SC-07', 'gabrielalejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(37, 'Myriam Sarai', 'Montor Pineda', 'SC-08', 'myriamsarai@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(38, 'Oscar', 'Nava Hernandez', 'SC-16', 'oscar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(39, 'Jorge Antonio', 'Obregon Rodriguez', 'SC-09', 'jorgeantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(40, 'Alejandro', 'Ochoa Serrano', 'SC-28', 'alejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(41, 'Maria Yoali', 'Perez Rivera', 'SC-47', 'mariayoali@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(42, 'Jose Antonio', 'Piñon Ridriguez', 'SC-21', 'joseantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(43, 'Damian Paul', 'Portilla Valencia', 'SC-43', 'damianpaul@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(44, 'Rocio', 'Ramirez Flores', 'SC-01', 'rocio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(45, 'Jesus Vicente', 'Rendon Acosta', 'SC-14', 'jesusvicente@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(46, 'Jorge Osmain', 'Rivas Gonzalez', 'SC-40', 'jorgeosmain@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(47, 'Heriberto', 'Rodriguez Cortes', 'SC-30', 'heriberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(48, 'Rair Jesus', 'Rodriguez Ortiz', 'SC-12', 'rairjesus@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(49, 'Angel', 'Rodriguez Perez', 'SC-02', 'angel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(50, 'Diego Fabian', 'Segura Olvera', 'SC-44', 'diegofabian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(51, 'Erik', 'Tapia Garcia', 'SC-49', 'erik@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(52, 'Mayte', 'Torres Arenas', 'SC-15', 'mayte@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(53, 'Fernanda', 'Torres Perales', 'SC-26', 'fernanda@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(54, 'Alan Daniel', 'Velazquez Uribe', 'SC-17', 'alandaniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(55, 'Edgar Manuel', 'Villalba Caballero', 'SC-51', 'edgarmanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(56, 'David', 'Villegas Correa', 'SC-22', 'david@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(57, 'Emilio Felipe', 'Abarca Ortiz', 'AF-04', 'emiliofelipe@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(58, 'Vanessa Xaneiry', 'Aguilar Barrera', 'AF-41', 'vanessaxaneiry@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(59, ' Edgar Teodoro ', 'Andrade Torres', 'AF-264', 'edgarteodoro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(60, 'Elda Sarahi', 'Arenas Martinez', 'AF-139', 'eldasarahi@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(61, 'Diana', 'Armendariz Sandoval', 'AF-42', 'diana@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(62, 'Omar Adrian', 'Arriaga Torres', 'AF-195', 'omaradrian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(63, 'Jonathan Francisco ', 'Arrieta Gutierrez', 'AF-137', 'jonathanfrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(64, 'Jesus Enrique ', 'Arroyo Cazares', 'AF-233', 'jesusenrique@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(65, 'Brayan', 'Ayala Sanchez', 'AF-244', 'brayan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(66, 'Yovanni Gaciel ', 'Ayehualtencatl Peña', 'AF-235', 'yovannigaciel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(67, 'Maria Daniel ', 'Badillo Santa', 'AF-246', 'mariadaniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(68, 'Jonathan', 'Barragan Gonzalez', 'AF-58', 'jonathan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(69, 'Rebeca Jazmine', 'Bermudez Galindo', 'AF-155', 'rebecajazmine@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(70, 'Gabriel', 'Bolañoz Martinez', 'AF-25', 'gabriel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(71, 'Margarita ', 'Botello Muñoz', 'AF-167', 'margarita@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(72, 'Eduardo', 'Brendel Rodriguez', 'AF-247', 'eduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(73, 'Luis Angel ', 'Cabrera Santos', 'AF-111', 'luisangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(74, 'Santiago de Jesus', 'Cabrera Vilchis', 'AF-199', 'santiagodejesus@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(75, 'Alan Manuel', 'Calderon Tello', 'AF-187', 'alanmanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(76, 'Victor Damian', 'Caloca Salvador', 'AF-32', 'victordamian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(77, 'Ricardo Daniel ', 'Camacho Olvera', 'AF-132', 'ricardodaniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(78, 'Cesar Tlatoani', 'Canales Cruz', 'AF-29', 'cesartlatoani@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(79, 'Alberto ', 'Cano Negrete', 'AF-84', 'alberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(80, 'Brayan Abdiel', 'Castro Caballero', 'AF-248', 'brayanabdiel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(81, 'Jean Israel', 'Castro Rodriguez', 'AF-09', 'jeanisrael@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(82, 'Abel Armando', 'Chavez Guzman', 'AF-3639', 'abelarmando@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(83, 'Victor Hugo ', 'Chavez Guzman', 'AF-2396', 'victorhugo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(84, 'Daniel', 'Contreras Caballero', 'AF-191', 'daniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(85, 'Julio Cesar', 'Cuevas Cerritos', 'AF-81', 'juliocesar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(86, 'Roberto ', 'Davila Martinez', 'AF-98', 'roberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(87, 'Hernandez Christian', 'Del Campo', 'AF-156', 'hernandezchristian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(88, 'Marin Hugo Cesar ', 'Del Rio', 'AF-204', 'marinhugocesar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(89, 'Ariana ', 'Delgadillo Galvan', 'AF-89', 'ariana@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(90, 'Nelibeth Bibiana', 'Diaz Ledezma', 'AF-86', 'nelibethbibiana@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(91, 'Elizabeth ', 'Dominguez Gallardo', 'AF-2401', 'elizabeth@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(92, 'Rosa Araceli', 'Dominguez Hernandez', 'AF-44', 'rosaaraceli@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(93, 'Arturo Emanuel', 'Dorado Hernandez', 'AF-69', 'arturoemanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(94, 'Alejandro Alonso ', 'Duran Hipolito', 'AF-210', 'alejandroalonso@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(95, 'Michel', 'Duran Olmedo', 'AF-74', 'michel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(96, 'Mario', 'Espinosa Gomez', 'AF-196', 'mario@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(97, 'Francisco ', 'Espinosa Ramirez', 'AF-138', 'francisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(98, 'Jose Francisco', 'Flores Hernandez', 'AF-223', 'josefrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(99, 'Emanuel', 'Flores Salgado', 'AF-55', 'emanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(100, 'Jonathan Uriel ', 'Galicia Cruz', 'AF-218', 'jonathanuriel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(101, 'Xitlali', 'Gama Jimenez', 'AF-18', 'xitlali@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(102, 'Alan Uriel ', 'Garcia Alonso', 'AF-217', 'alanuriel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(103, 'Angel Martin ', 'Garcia Bautista', 'AF-207', 'angelmartin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(104, 'Luis Roberto ', 'Garcia Bautista', 'AF-249', 'luisroberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(105, 'Eduardo Daniel ', 'Garcia Garcia', 'AF-250', 'eduardodaniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(106, 'Andres', 'Garcia Hernandez', 'AF-93', 'andres@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(107, 'Mario Yahir', 'Garcia Juarez', 'AF-03', 'marioyahir@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(108, 'Manuel Arturo', 'Garcia Martinez', 'AF-22999', 'manuelarturo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(109, 'Gloria', 'Garcia Serna', 'AF-21', 'gloria@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(110, 'Andrik Uriel', 'Garcia Serrano', 'AF-37', 'andrikuriel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(111, 'Ulises Adrian', 'Garcia Serrano', 'AF-08', 'ulisesadrian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(112, 'Juan Carlos', 'Garcia Venegas', 'AF-22492', 'juancarlos@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(113, 'Juan Jose', 'Garcia Venegas', 'AF-190', 'juanjose@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(114, 'Victor Antonio ', 'Garcia Xicali', 'AF-237', 'victorantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(115, 'Jose Maria', 'Garibay Aparicio', 'AF-23206', 'josemaria@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(116, 'Jesus Aldair', 'Garnica Hernandez', 'AF-23', 'jesusaldair@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(117, 'Jonathan ', 'Garrido Perez', 'AF-2396', 'jonathan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(118, 'Valetin ', 'Gayosso Soto', 'AF-236', 'valetin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(119, 'Alexis Aldair ', 'Gomez Chavez', 'AF-173', 'alexisaldair@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(120, 'Luis Alberto', 'Gonzalez Gutierres', 'AF-245', 'luisalberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(121, 'Alan Diego', 'Gonzalez Hernandez', 'AF-182', 'alandiego@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(122, 'Juan Carlos ', 'Gonzalez Lopez', 'AF-23035', 'juancarlos@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(123, 'Mario Walfred', 'Gonzalez Lopez', 'AF-251', 'mariowalfred@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(124, 'Erika Naivid', 'Gonzalez Maldonado', 'AF-153', 'erikanaivid@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(125, 'Armando Yair', 'Gonzalez Muñoz', 'AF-186', 'armandoyair@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(126, 'Josue Ismael ', 'Gonzalez Samaniego', 'AF-157', 'josueismael@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(127, 'Joel ', 'Gonzalez Ventura', 'AF-206', 'joel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(128, 'Eduardo', 'Guerrero Fuentes', 'AF-13', 'eduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(129, 'Ricardo', 'Guerrero Garcia', 'AF-166', 'ricardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(130, 'Miguel Angel ', 'Gutierrez Brizuela', 'AF-125', 'miguelangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(131, 'Edgar Martin', 'Gutierrez Diaz', 'AF-73', 'edgarmartin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(132, 'Fernando ', 'Gutierrez Salinas', 'AF-113', 'fernando@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(133, 'Daniela', 'Gutierrez Tapia', 'AF-151', 'daniela@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(134, 'Jonathan Raul', 'Gutierrez Vazquez', 'AF-226', 'jonathanraul@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(135, 'Maria del Carmen ', 'Hernandez Cortes', 'AF-221', 'mariadelcarmen@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(136, 'Jurgen Michell ', 'Hernandez Flores', 'AF-119', 'jurgenmichell@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(137, 'Mario Antonio ', 'Hernandez Flores', 'AF-104', 'marioantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(138, 'Ana Karen ', 'Hernandez Gomez', 'AF-114', 'anakaren@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(139, 'Edgar', 'Hernandez Lopez', 'AF-164', 'edgar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(140, 'Isaac Armando ', 'Hernandez Lopez', 'AF-107', 'isaacarmando@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(141, 'Fernando', 'Hernandez Maya', '30100', 'fernando@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(142, 'Jazmin ', 'Hernandez Monter', 'AF-83', 'jazmin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(143, 'Israel', 'Huerta Aranda', 'AF-75', 'israel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(144, 'Ismael', 'Iturbe Mendoza', 'AF-162', 'ismael@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(145, 'Kevin Omar', 'Jacuinde Salazar', 'AF-189', 'kevinomar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(146, 'Marcos ', 'Jaime Lujano', '103', 'marcos.jaime@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '12135874', '2023-10-09 16:16:22', NULL, NULL, 1),
(147, 'Pedro Angel', 'Jaimes Guzman', 'AF-242', 'pedroangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(148, 'Luis Jeronimo', 'Jimenez Garcia', 'AF-23208', 'luisjeronimo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(149, 'Hector', 'Jimenez Ibarra', 'AF-158', 'hector@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(150, 'Javier ', 'Jimenez Marques', 'AF-215', 'javier@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(151, 'Diana Belem', 'Jimenez Martinez', 'AF-150', 'dianabelem@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(152, 'Marcial ', 'Jimenez Rodriguez', 'AF-252', 'marcial@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(153, 'Jorge Abraham', 'Jimenez Rojo', 'AF-46', 'jorgeabraham@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(154, 'Imelda', 'Juarez Cruz', 'AF-22998', 'imelda@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(155, 'Luis Gael', 'Juarez Hernandez', 'AF-24', 'luisgael@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(156, 'Andres', 'Leyte Manrrique', 'AF-211', 'andres@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(157, 'Cesar Alexis ', 'Lopez Camacho', 'AF-201', 'cesaralexis@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(158, 'Cesar Ariel', 'Lopez Camacho', 'AF-203', 'cesarariel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(159, 'Agustina', 'Lopez Cruz', 'AF-23035', 'agustina@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(160, 'Armando', 'Lopez Gonzalez', 'AF-95', 'armando@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(161, 'Jorge Eduardo', 'Lopez Gonzalez', 'AF-192', 'jorgeeduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(162, 'Enrique ', 'Lugo Martinez', 'AF-127', 'enrique@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(163, 'Berenice', 'Luna Allier', 'AF-88', 'berenice@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(164, 'Laura Angelica ', 'Luna Buendia', 'AF-129', 'lauraangelica@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(165, 'Nestor Ignacio', 'Macias Luna', 'AF-50', 'nestorignacio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(166, 'Miguel ', 'Macias Maldonado', 'AF-253', 'miguel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(167, 'Omar Eduardo ', 'Macias Oble', 'AF-254', 'omareduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(168, 'Luis Daniel', 'Magdaleno Baeza', 'AF-34', 'luisdaniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(169, 'Jose Raymundo', 'Martinez Alvarez', 'AF-51', 'joseraymundo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(170, 'Luis Alberto ', 'Martinez Casiano', 'AF-231', 'luisalberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(171, 'Francisco', 'Martinez Gallegos', 'AF-170', 'francisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(172, 'Ricardo ', 'Martinez Gaspar', 'AF-145', 'ricardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(173, 'Jorge Ivan ', 'Martinez Hernandez', 'AF-2420', 'jorgeivan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(174, 'Juan Manuel', 'Martinez Hernandez', 'AF-47', 'juanmanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(175, 'Daniel ', 'Martinez Martinez', 'AF-202', 'daniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(176, 'Gilberto ', 'Martinez Ortega', 'AF-255', 'gilberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(177, 'Edwin Emanuel', 'Martinez Sanchez', 'AF-256', 'edwinemanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(178, 'Julio Cesar ', 'Martinez Suarez', 'AF-96', 'juliocesar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(179, 'Donovan', 'Medellin Patlan', 'AF-257', 'donovan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(180, 'Miguel Angel', 'Medina Granados', 'AF-154', 'miguelangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 14, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(181, 'Carlos ', 'Medina Vega Roberto', 'AF-240', 'carlos@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(182, 'Angel', 'Mendez Canales', 'AF-141', 'angel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(183, 'Marco Antonio', 'Mendoza Guzman', 'AF-185', 'marcoantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(184, 'Ana Rosa ', 'Mendoza Quintero', 'AF-131', 'anarosa@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(185, 'Irving Francisco', 'Mondragon Mancilla', 'AF-19954', 'irvingfrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(186, 'Carlos Daniel ', 'Morales Gonzalez', 'AF-205', 'carlosdaniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(187, 'Daniel Humberto', 'Moreno Alcantar', 'AF-76', 'danielhumberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(188, 'Hector Alejandro ', 'Moreno Reyna', 'AF-208', 'hectoralejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(189, 'Miguel Angel', 'Muñoz Garcia', 'AF-219', 'miguelangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(190, 'Jesus Antonio ', 'Nava Anaya', 'AF-213', 'jesusantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(191, 'Abraham Alejandro', 'Nava Rojas', 'AF-53', 'abrahamalejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(192, 'Erick Miguel ', 'Nava Sanchez', 'AF-174', 'erickmiguel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(193, 'Brenda Nataly', 'Nieto Castañeda', 'AF', 'brendanataly@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '1', '2023-10-09 16:16:22', NULL, '2023-10-26 14:00:15', 0),
(194, 'Jose Marcos', 'Nuñez Dominguez', 'AF-59', 'josemarcos@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(195, 'Esteban ', 'Olguin Nolasco', 'AF-115', 'esteban@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(196, 'Brandon Axel', 'Oliva Robledo', 'AF-135', 'brandonaxel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(197, 'Lesli Yaremi', 'Olvera Rodriguez', 'AF-227', 'lesliyaremi@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(198, 'Maria del Rosario', 'Orozco Rosario', 'AF-94', 'mariadelrosario@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(199, 'Luis Alfredo ', 'Ortega Covarrubias', 'AF-183', 'luisalfredo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(200, 'Ivan ', 'Ortega Diaz', 'AF-225', 'ivan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(201, 'Jose Alexei', 'Ortega Molina', 'AF-212', 'josealexei@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(202, 'Joaquin ', 'Otañez Cazarez', 'AF-149', 'joaquin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(203, 'Francisco Efrain', 'Parra Oropeza', 'AF-142', 'franciscoefrain@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(204, 'Itzmatl Damian', 'Peralta Perez', 'AF-05', 'itzmatldamian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(205, 'Leonides Francisco ', 'Perez Acleto', 'AF-180', 'leonidesfrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(206, 'Owen Axel ', 'Perez Manzur', 'AF-92', 'owenaxel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(207, 'Julio', 'Perez Orta', 'AF-26', 'julio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(208, 'Miguel Angel', 'Perez Orta', 'AF-12', 'miguelangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(209, 'Victor Hugo ', 'Perez Padilla', 'AF-234', 'victorhugo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(210, 'Gilberto ', 'Perez Ramirez', 'AF-116', 'gilberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(211, 'Jesus Angel', 'Pineda Arriaga', 'AF-241', 'jesusangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(212, 'Yoman Francisco ', 'Piscil Fuentes', 'AF-238', 'yomanfrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(213, 'Fatima Yoselin', 'Quintero Corona', 'AF-60', 'fatimayoselin@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(214, 'Rogelio ', 'Ramiez Torres', 'AF-232', 'rogelio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(215, 'Giovanni', 'Ramirez Nava', 'AF-23205', 'giovanni@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(216, 'Victor Enrique', 'Ramirez Rendon', 'AF-16', 'victorenrique@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(217, 'Christian Ivan', 'Real Ramirez', 'AF-194', 'christianivan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(218, 'Juan David', 'Recoba Altamirano', 'AF-198', 'juandavid@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(219, 'Arath', 'Rendon Acosta', 'AF-35', 'arath@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(220, 'Emory', 'Reyes Martinez', 'AF-62', 'emory@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(221, 'Jose Manuel', 'Reyes Martinez', 'AF-222', 'josemanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(222, 'Edgar ', 'Rios Gonzlez', 'AF-258', 'edgar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(223, 'Victor Antonio ', 'Rivera Flores', 'AF-110', 'victorantonio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(224, 'Juan de Dios ', 'Rivera Rodriguez', 'AF-172', 'juandedios@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(225, 'Jose Luis', 'Rivera Tellez', 'AF-79', 'joseluis@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(226, 'Magali Lucero', 'Rodrigez Garcia', 'AF-56', 'magalilucero@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(227, 'Mario Alberto ', 'Rodriguez Cruz', 'AF-117', 'marioalberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(228, 'Bryan ', 'Rodriguez Galvan', 'AF-216', 'bryan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(229, 'Miguel Angel ', 'Rodriguez Garcia', 'AF-228', 'miguelangel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(230, 'Arnold', 'Rodriguez Tagano', 'AF-159', 'arnold@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(231, 'Christopher Cenorino', 'Rodriguez Tagano', 'AF-163', 'christophercenorino@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(232, 'Juan Carlos', 'Rojas Bautista', 'AF-165', 'juancarlos@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(233, 'Sergio ', 'Rojas Rivera', 'AF-181', 'sergio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(234, 'Concepcion', 'Roque Cruz', 'AF-160', 'concepcion@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 14, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(235, 'Ceron Jair David', 'Ruiz Velazco', 'AF-72', 'ceronjairdavid@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(236, 'Eduardo', 'Salazar Contreras', 'AF-259', 'eduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(237, 'Giron Jovanny', 'Salazar Tellez', 'AF-169', 'gironjovanny@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(238, 'Juan Manuel ', 'Salguero Garcia', 'AF-260', 'juanmanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(239, 'Lorena', 'Salinas Ramirez', 'AF-143', 'lorena@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(240, 'Hernandez Salvador', 'San Juan', 'AF-64', 'hernandezsalvador@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(241, 'Jonathan Israel', 'Sanchez Aguilera', 'AF-19256', 'jonathanisrael@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 15, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(242, 'Jose Nicolas ', 'Sanchez Chavez', 'AF-220', 'josenicolas@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(243, 'Johan Mohamed', 'Sanchez Garay', 'AF-171', 'johanmohamed@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(244, 'Veronica ', 'Sanchez Hernandez', 'AF-112', 'veronica@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, '2023-11-19 08:36:58', 0),
(245, 'Johan Miguel', 'Sanchez Jorge', 'AF-200', 'johanmiguel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(246, 'Jose Luis', 'Sanchez Vara', 'AF-23109', 'joseluis@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(247, 'Leopoldo', 'Sandoval alvarez', 'AF-23179', 'leopoldo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(248, 'David Gerson ', 'Santiago Rodriguez', 'AF-78', 'davidgerson@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(249, 'Axel Alfredo', 'Santiago Sanchez', 'AF-49', 'axelalfredo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(250, 'Eva', 'Tellez Lopez', 'AF-152', 'eva@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 14, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(251, 'Victor ', 'Torres Cruz', 'AF-229', 'victor@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(252, 'Juan ', 'Torres Ibarra', 'AF-123', 'juan@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(253, 'Jorge Osvaldo ', 'Torres Sanchez', 'AF-85', 'jorgeosvaldo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(254, 'Jeronimo ', 'Ugalde Espino', 'AF-214', 'jeronimo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(255, 'Axel', 'Uribe Jimenez', 'AF-15', 'axel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(256, 'Jose Eduardo ', 'Hernandez Vazquez', 'AF-140', 'joseeduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(257, 'Jose Francisco ', 'Perez Vallejo', 'AF-118', 'josefrancisco@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(258, 'Jonathan Alejandro ', 'Reyes Perez', 'AF-121', 'jonathanalejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(259, 'Jose Alberto ', 'Trejo Torres', 'AF-270', 'josealberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(260, 'Victor Hugo', 'Gonzalez Gomez', 'AF-265', 'victorhugo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(261, 'Cruz Jesus ', 'Valdez de', 'AF-209', 'cruzjesus@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(262, 'Juan Pablo', 'Valladolid Habana', 'AF-146', 'juanpablo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(263, 'Jorge Joel ', 'Vargas Acosta', 'AF-261', 'jorgejoel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(264, 'Daniel ', 'Vazquez Duran', 'AF-262', 'daniel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(265, 'Eduardo', 'Vazquez Lopez', 'AF-161', 'eduardo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 13, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(266, 'Ulises Alejandro', 'Vazquez Lopez', 'AF-177', 'ulisesalejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(267, 'Jacqueline', 'Vega Carrasco', 'SC-20', 'jacqueline@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(268, 'Alfonso', 'Martinez Perez', 'AF-225', 'alfonso@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 7, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(269, 'Hugo ', 'Vences Martinez', 'AF-80', 'hugo@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(270, 'Mario Alberto', 'Victoria Garcia', 'AF-71', 'marioalberto@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 16, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(271, 'Lucio', 'Zarate Lopez', 'AF-243', 'lucio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(272, 'Vianey', 'Alcantara Arroniz', 'OR-44', 'vianey@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(273, 'Julio Cesar', 'Cortes Lopez', 'OR-47', 'juliocesar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(274, 'Raul Sebastian', 'Hernandez Granados', 'OR-50', 'raulsebastian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 3, 1, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(275, 'Joshua', 'Duran Amezcua', 'M-21', 'joshua@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(276, 'Ramon', 'Espitia Martinez', 'M-20971', 'ramon@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(277, 'Brenda Riccel', 'Flores Alcantara', 'M-2404', 'brendariccel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 10, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(278, 'Jesus Alejandro ', 'Garcia Huerta', 'M-02', 'jesusalejandro@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(279, 'Juan Manuel', 'Hernandez Martinez', 'M-2413', 'juanmanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 11, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(280, 'Reyes ', 'Lopez Lardizabal', 'M-2417', 'reyes@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(281, 'Christian Jibran', 'Rodriguez Ramirez', 'M-15', 'christianjibran@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 5, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(282, 'Erick', 'Santos Victoria', 'M-21027', 'erick@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(283, 'Erick Uriel', 'Zepeda Flores', 'M-15978', 'erickuriel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 5, 8, 3, '1', '2023-10-09 16:16:22', NULL, NULL, 1),
(284, 'Haydee', 'Ortiz', '1574', 'auxsist5_solulogis@outlook.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 1, 1, '9982421738', '2023-10-10 12:06:45', NULL, NULL, 1),
(285, 'Gamaliel', 'Amaro', '12345', 'gamaliel.amaro@solulogis.net', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 1, 3, '018009998080', '2023-10-11 08:42:30', NULL, NULL, 1),
(286, 'Chrysthian Isaury', 'Hernández', '1234', 'chrysthian@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '5512345678', '2023-10-16 12:51:19', NULL, NULL, 1),
(287, 'Cesar', 'Padilla', '366047', 'cesar@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 2, '5512345678', '2023-10-16 15:59:13', NULL, NULL, 1),
(290, 'Julio Cesar', 'Baez', '7676', 'julio@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '1', '2023-10-18 15:27:19', NULL, NULL, 1),
(291, 'Brain Luna', 'Guzmán', '6363', 'brain@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '1', '2023-10-18 15:54:31', NULL, NULL, 1),
(292, 'Brenda Joceline', 'Gutiérrez Tranquilino', '8990', 'brendajoceline@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 2, 3, '1', '2023-10-23 18:15:51', NULL, NULL, 1),
(293, 'Itzel', 'Hernández Tejeda', 'AF-63', 'itzel.hernandez@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '5544882881', '2023-10-26 10:43:25', NULL, '2023-10-26 14:03:24', 1),
(294, 'prueba', 'asdf', '123456', 'prueba@gmail.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '1', '2023-10-26 14:51:34', NULL, '2023-10-26 14:52:00', 0),
(295, 'Emmanuel', 'Martínez Romo', '4554', 'emmanuel@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-10-27 14:10:12', NULL, NULL, 1),
(297, 'Mariana Alejandra ', 'Feria Mendoza', '101', 'administracion-2@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '5530643155', '2023-11-18 12:11:13', NULL, NULL, 1),
(298, 'Francisco Javier', 'Moreno Guerrero', '7898', 'franciscojavier@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '1', '2023-11-19 08:48:22', NULL, NULL, 1),
(299, 'Miguel ', 'Maceda', '102', 'miguel.maceda@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 6, 3, '12345689', '2023-11-24 10:54:31', NULL, NULL, 1),
(300, 'Jibran', 'Rodriguez Ramirez', '104', 'jibran@cco.com.mx', '0298f96c3bd7fc8f11bea5b8d6e562cf', 2, 4, 3, '12587496', '2023-12-27 09:16:04', NULL, NULL, 1),
(301, 'Paola', 'Valencia', '2056', 'implementacion1@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 17, 3, '9851153386', '2023-12-28 12:33:04', NULL, NULL, 1),
(302, 'Gabriela', 'Canul', '2059', 'implementacion2@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 17, 3, '9992622156', '2023-12-28 12:37:51', NULL, NULL, 1),
(303, 'Jairo', 'Vazquez', '1765', 'implementacion4@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 17, 3, '2491464739', '2023-12-28 12:43:30', NULL, NULL, 1),
(304, 'Sandra', 'Zarate', '145', 'sandra.zarate@solulogis.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 1, 17, 1, '5569680887', '2023-12-28 15:07:13', NULL, NULL, 1),
(305, 'Prueba', 'prueba', '55555', 'prueba@gmail.com', '0298f96c3bd7fc8f11bea5b8d6e562cf', 3, 3, 1, '1', '2023-12-28 18:24:56', NULL, NULL, 1);

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
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `pausas_ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  MODIFY `not_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  MODIFY `prio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  MODIFY `cats_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT de la tabla `tm_tarea`
--
ALTER TABLE `tm_tarea`
  MODIFY `id_tarea` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  MODIFY `tick_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tm_usr_cat`
--
ALTER TABLE `tm_usr_cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=302;

--
-- AUTO_INCREMENT de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

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
