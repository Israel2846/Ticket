-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-10-2023 a las 07:48:16
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

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `filtrar_ticket`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_ticket` (IN `tick_titulo` VARCHAR(50), IN `cat_id` INT, IN `prio_id` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `filtrar_ticket2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_ticket2` (IN `tick_titulo` VARCHAR(50), IN `cat_id` INT, IN `prio_id` INT)   SELECT 

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

DROP PROCEDURE IF EXISTS `sp_d_usuario_01`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_d_usuario_01` (IN `xusu_id` INT)   BEGIN

	UPDATE tm_usuario 

	SET 

		est='0',

		fech_elim = now() 

	where usu_id=xusu_id;

END$$

DROP PROCEDURE IF EXISTS `sp_i_ticketdetalle_01`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_i_ticketdetalle_01` (IN `xtick_id` INT, IN `xusu_id` INT)   BEGIN
	INSERT INTO td_ticketdetalle 
    (tickd_id,tick_id,usu_id,tickd_descrip,fech_crea,est) 
    VALUES 
    (NULL,xtick_id,xusu_id,'Ticket Cerrado...',now(),'1');
END$$

DROP PROCEDURE IF EXISTS `sp_l_reporte_01`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_reporte_01` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `sp_l_usuario_01`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_01` ()   BEGIN
	SELECT * FROM tm_usuario
        INNER JOIN tm_almacen ON 
        tm_usuario.usu_almacen = 
        tm_almacen.id_almacen
        INNER JOIN tm_area_almacen ON 
        tm_usuario.usu_area = 
        tm_area_almacen.id_area_almacen;
END$$

DROP PROCEDURE IF EXISTS `sp_l_usuario_02`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_02` (IN `xusu_id` INT)   BEGIN
	SELECT * FROM tm_usuario where usu_id=xusu_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento`
--

DROP TABLE IF EXISTS `td_documento`;
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

DROP TABLE IF EXISTS `td_documento_detalle`;
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

DROP TABLE IF EXISTS `td_documento_tarea`;
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

DROP TABLE IF EXISTS `td_documento_tarea_detalle`;
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

DROP TABLE IF EXISTS `td_pausas_ticket`;
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

DROP TABLE IF EXISTS `td_tareadetalle`;
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

DROP TABLE IF EXISTS `td_ticketdetalle`;
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

DROP TABLE IF EXISTS `tm_almacen`;
CREATE TABLE `tm_almacen` (
  `id_almacen` int(11) NOT NULL,
  `nombre_almacen` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_area_almacen`
--

DROP TABLE IF EXISTS `tm_area_almacen`;
CREATE TABLE `tm_area_almacen` (
  `id_area_almacen` int(11) NOT NULL,
  `id_almacen` int(11) NOT NULL,
  `nombre_area` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_categoria`
--

DROP TABLE IF EXISTS `tm_categoria`;
CREATE TABLE `tm_categoria` (
  `cat_id` int(11) NOT NULL,
  `cat_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_notificacion`
--

DROP TABLE IF EXISTS `tm_notificacion`;
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

DROP TABLE IF EXISTS `tm_prioridad`;
CREATE TABLE `tm_prioridad` (
  `prio_id` int(11) NOT NULL,
  `prio_nom` varchar(50) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_subcategoria`
--

DROP TABLE IF EXISTS `tm_subcategoria`;
CREATE TABLE `tm_subcategoria` (
  `cats_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_tarea`
--

DROP TABLE IF EXISTS `tm_tarea`;
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

DROP TABLE IF EXISTS `tm_ticket`;
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
-- Estructura de tabla para la tabla `tm_usuario`
--

DROP TABLE IF EXISTS `tm_usuario`;
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
-- Indices de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  ADD PRIMARY KEY (`usu_id`),
  ADD KEY `fk_id_almacen_usuario` (`usu_almacen`),
  ADD KEY `fk_id_area_usuario` (`usu_area`);

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
  MODIFY `id_almacen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_area_almacen`
--
ALTER TABLE `tm_area_almacen`
  MODIFY `id_area_almacen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_notificacion`
--
ALTER TABLE `tm_notificacion`
  MODIFY `not_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  MODIFY `prio_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  MODIFY `cats_id` int(11) NOT NULL AUTO_INCREMENT;

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
-- AUTO_INCREMENT de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `fk_id_tarea_detalle` FOREIGN KEY (`id_tarea`) REFERENCES `tm_tarea` (`id_tarea`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Filtros para la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  ADD CONSTRAINT `fk_id_almacen_usuario` FOREIGN KEY (`usu_almacen`) REFERENCES `tm_almacen` (`id_almacen`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_area_usuario` FOREIGN KEY (`usu_area`) REFERENCES `tm_area_almacen` (`id_area_almacen`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
