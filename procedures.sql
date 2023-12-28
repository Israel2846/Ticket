-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 28-12-2023 a las 16:39:57
-- Versión del servidor: 5.7.44
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sol114_tickets`
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

CREATE DEFINER=`sol114`@`localhost` PROCEDURE `sp_l_usuario_01` ()   BEGIN
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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
