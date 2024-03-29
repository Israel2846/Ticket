<?php

class Ticket extends Conectar
{
    // Obtener todos los registros
    public function get_ticket()
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT * FROM tm_ticket";
            $sql = $conectar->prepare($sql);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Obtener solo un registro
    public function get_one_ticket($id_ticket)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT * FROM tm_ticket where tick_id = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_ticket);
            $sql->execute();

            return $sql->fetch();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Pausar ticket
    public function pause_ticket($id_ticket, $id_usuario)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            // Cambiar estado del ticket a Pausado
            $sql = "UPDATE tm_ticket SET tm_ticket.tick_estado = 'Pausado' WHERE tm_ticket.tick_id = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1, $id_ticket);
            $sql->execute();

            // Insertar registro con fecha en la que fue pausado
            $sql2 = "INSERT INTO td_pausas_ticket (td_pausas_ticket.id_ticket, td_pausas_ticket.id_usuario, td_pausas_ticket.fecha_pausa) 
                        VALUES (?, ?, now())";
            $sql2 = $conectar->prepare($sql2);
            $sql2->bindParam(1, $id_ticket);
            $sql2->bindParam(2, $id_usuario);
            $sql2->execute();

            return true;
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Reanudar ticket
    public function resume_ticket($id_ticket)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            // Cambiar estado del ticket a En proceso
            $sql = "UPDATE tm_ticket SET tm_ticket.tick_estado = 'En proceso' WHERE tm_ticket.tick_id = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1, $id_ticket);
            $sql->execute();

            // Actualizar el proceso de pausado con la fecha de reanudado
            $sql2 = "UPDATE td_pausas_ticket
                        SET td_pausas_ticket.fecha_reanuda = now()
                        WHERE td_pausas_ticket.pausas_ticket_id = (
                            SELECT MAX(td_pausas_ticket.pausas_ticket_id)
                            FROM td_pausas_ticket
                            WHERE td_pausas_ticket.id_ticket = ?
                        )";
            $sql2 = $conectar->prepare($sql2);
            $sql2->bindParam(1, $id_ticket);
            $sql2->execute();

            echo true;
        } catch (Exception $e) {
            echo $e->getMessage();
        }
    }

    /* TODO: insertar nuevo ticket */
    public function insert_ticket($usu_id, $cat_id, $cats_id, $tick_titulo, $tick_descrip, $prio_id, $usu_reporta = null)
    {
        $conectar = parent::conexion();

        parent::set_names();

        if ( is_null($usu_reporta)) {
            $usu_reporta = $usu_id;
        }

        $sql = "INSERT INTO tm_ticket (tick_id,usu_id,cat_id,cats_id,tick_titulo,tick_descrip,tick_estado,fech_crea,usu_asig,fech_asig,prio_id,est, usu_reporta) VALUES (NULL,?,?,?,?,?,'Abierto',now(),NULL,NULL,?,'1', ?);";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->bindValue(2, $cat_id);
        $sql->bindValue(3, $cats_id);
        $sql->bindValue(4, $tick_titulo);
        $sql->bindValue(5, $tick_descrip);
        $sql->bindValue(6, $prio_id);
        $sql->bindValue(7, $usu_reporta);
        $sql->execute();

        $sql1 = "select last_insert_id() as 'tick_id';";
        $sql1 = $conectar->prepare($sql1);
        $sql1->execute();

        return $sql1->fetchAll(pdo::FETCH_ASSOC);
    }

    /* TODO: Listar ticket segun id de usuario asignado */
    public function listar_ticket_x_usu($usu_id)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT 
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
                    tm_ticket.est = 1 AND tm_ticket.usu_asig = ?
                    ORDER BY FIELD(tm_ticket.tick_estado, 'Abierto', 'En proceso', 'Pausado', 'Cerrado') ASC, tm_ticket.prio_id DESC";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* TODO: Listar ticket segun almacen de usuario asignado */
    function listar_ticket_x_almacen($usu_id)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT 
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
                tm_ticket.est = 1 AND tm_ticket.usu_asig IN (
                    SELECT tm_usuario.usu_id FROM tm_usuario WHERE tm_usuario.usu_almacen = (
                        SELECT tm_usuario.usu_almacen FROM tm_usuario WHERE tm_usuario.usu_id = ?
                    )
                ) AND (tm_ticket.tick_estado != 'Cerrado')
                ORDER BY FIELD(tm_ticket.tick_estado, 'Abierto', 'En proceso', 'Pausado') ASC, tm_ticket.prio_id ASC";

            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* TODO: Listar ticket segun id de usuario creador */
    public function listar_ticket_x_creador($usu_id)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT 
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
                    tm_ticket.est = 1 AND tm_ticket.usu_id = ?
                    ORDER BY FIELD(tm_ticket.tick_estado, 'Abierto', 'En proceso', 'Pausado', 'Cerrado') ASC, tm_ticket.prio_id ASC";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $usu_id);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* TODO: Mostrar ticket segun id de ticket */
    public function listar_ticket_x_id($tick_id)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT 
                tm_ticket.tick_id,
                tm_ticket.usu_id,
                tm_ticket.cat_id,
                tm_ticket.cats_id,
                tm_ticket.tick_titulo,
                tm_ticket.tick_descrip,
                tm_ticket.tick_estado,
                tm_ticket.fech_crea,
                tm_ticket.fech_cierre,
                tm_ticket.tick_estre,
                tm_ticket.tick_coment,
                tm_ticket.usu_asig,
                tm_usuario.usu_nom,
                tm_usuario.usu_ape,
                tm_usuario.usu_correo,
                tm_usuario.usu_telf,
                tm_categoria.cat_nom,
                tm_subcategoria.cats_nom,
                tm_ticket.prio_id,
                tm_prioridad.prio_nom
                FROM 
                tm_ticket
                INNER join tm_categoria on tm_ticket.cat_id = tm_categoria.cat_id
                INNER join tm_subcategoria on tm_ticket.cats_id = tm_subcategoria.cats_id
                INNER join tm_usuario on tm_ticket.usu_id = tm_usuario.usu_id
                INNER join tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
                WHERE
                tm_ticket.est = 1
                AND tm_ticket.tick_id = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $tick_id);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* TODO: Mostrar todos los ticket */
    public function listar_ticket_abierto($cat_id)
    {
        $concat = "";

        if ($cat_id == 0) {
            $concat = " IN (SELECT DISTINCT tm_categoria.cat_id FROM tm_categoria) ";
        } else {
            $concat = " = {$cat_id} ";
        }

        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT
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
                        creador.usu_nom,
                        creador.usu_ape,
                        asignado.usu_nom AS asignado,
                        tm_categoria.cat_nom,
                        tm_ticket.prio_id,
                        tm_prioridad.prio_nom,
                        tm_almacen.nombre_almacen,
                        tm_area_almacen.nombre_area,
                        CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_crea, tm_ticket.fech_asig), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_crea, tm_ticket.fech_asig)%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_crea, tm_ticket.fech_asig)%60, ' minutos') AS timeresp,
                        CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_crea, NOW()), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_crea, NOW())%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_crea, NOW())%60, ' minutos') AS timetransc,
                        CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_asig, tm_ticket.fech_cierre), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_asig, tm_ticket.fech_cierre)%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_asig, tm_ticket.fech_cierre)%60, ' minutos') AS timetarea,
                        CONCAT(TIMESTAMPDIFF (DAY, tm_ticket.fech_crea, tm_ticket.fech_cierre), ' dias ', TIMESTAMPDIFF (HOUR, tm_ticket.fech_crea, tm_ticket.fech_cierre)%24, ' horas ', TIMESTAMPDIFF (MINUTE, tm_ticket.fech_crea, tm_ticket.fech_cierre)%60, ' minutos') AS tiempototal
                    FROM
                        tm_ticket
                    INNER join tm_categoria on tm_ticket.cat_id = tm_categoria.cat_id
                    LEFT join tm_usuario AS creador on tm_ticket.usu_id = creador.usu_id
                    LEFT JOIN tm_usuario as asignado on tm_ticket.usu_asig = asignado.usu_id
                    INNER join tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
                    INNER JOIN tm_area_almacen ON creador.usu_area = tm_area_almacen.id_area_almacen
                    INNER JOIN tm_almacen on creador.usu_almacen = tm_almacen.id_almacen
                    WHERE
                        tm_ticket.est = 1 and tm_ticket.tick_estado = 'Abierto'
                        AND tm_ticket.cat_id {$concat}
                    ORDER BY tm_ticket.prio_id ASC";
            $sql = $conectar->prepare($sql);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    public function listar_ticket_en_proceso($cat_id)
    {
        $concat = "";

        if ($cat_id == 0) {
            $concat = " IN (SELECT DISTINCT tm_categoria.cat_id FROM tm_categoria) ";
        } else {
            $concat = " = {$cat_id} ";
        }

        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT
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
                        creador.usu_nom,
                        creador.usu_ape,
                        asignado.usu_nom AS asignado,
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
                    LEFT join tm_usuario AS creador on tm_ticket.usu_id = creador.usu_id
                    LEFT JOIN tm_usuario as asignado on tm_ticket.usu_asig = asignado.usu_id
                    INNER join tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
                    WHERE
                        tm_ticket.est = 1 and tm_ticket.tick_estado = 'En proceso'
                        AND tm_ticket.cat_id {$concat}
                    ORDER BY tm_ticket.prio_id ASC";
            $sql = $conectar->prepare($sql);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    public function listar_ticket_pausados($cat_id)
    {
        $concat = "";

        if ($cat_id == 0) {
            $concat = " IN (SELECT DISTINCT tm_categoria.cat_id FROM tm_categoria) ";
        } else {
            $concat = " = {$cat_id} ";
        }

        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT
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
                        creador.usu_nom,
                        creador.usu_ape,
                        asignado.usu_nom AS asignado,
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
                    LEFT join tm_usuario AS creador on tm_ticket.usu_id = creador.usu_id
                    LEFT JOIN tm_usuario as asignado on tm_ticket.usu_asig = asignado.usu_id
                    INNER join tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
                    WHERE
                        tm_ticket.est = 1 and tm_ticket.tick_estado = 'Pausado'
                        AND tm_ticket.cat_id {$concat}
                    ORDER BY tm_ticket.prio_id ASC";
            $sql = $conectar->prepare($sql);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    public function listar_ticket_cerrado($cat_id)
    {
        $concat = "";

        if ($cat_id == 0) {
            $concat = " IN (SELECT DISTINCT tm_categoria.cat_id FROM tm_categoria) ";
        } else {
            $concat = " = {$cat_id} ";
        }

        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "SELECT
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
                        creador.usu_nom,
                        creador.usu_ape,
                        asignado.usu_nom AS asignado,
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
                    LEFT join tm_usuario AS creador on tm_ticket.usu_id = creador.usu_id
                    LEFT JOIN tm_usuario as asignado on tm_ticket.usu_asig = asignado.usu_id
                    INNER join tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
                    WHERE
                        tm_ticket.est = 1 and tm_ticket.tick_estado = 'Cerrado'
                        AND tm_ticket.cat_id {$concat}
                    ORDER BY tm_ticket.prio_id ASC";
            $sql = $conectar->prepare($sql);
            $sql->execute();

            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /* TODO: Mostrar detalle de ticket por id de ticket */
    public function listar_ticketdetalle_x_ticket($tick_id)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "SELECT
                td_ticketdetalle.tickd_id,
                td_ticketdetalle.tickd_descrip,
                td_ticketdetalle.fech_crea,
                tm_usuario.usu_nom,
                tm_usuario.usu_ape,
                tm_usuario.rol_id
                FROM 
                td_ticketdetalle
                INNER join tm_usuario on td_ticketdetalle.usu_id = tm_usuario.usu_id
                WHERE 
                tick_id =?";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $tick_id);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Insert ticket detalle */
    public function insert_ticketdetalle($tick_id, $usu_id, $tickd_descrip)
    {
        $conectar = parent::conexion();

        parent::set_names();

        /* TODO:Obtener usuario asignado del tick_id */
        $ticket = new Ticket();

        $datos = $ticket->listar_ticket_x_id($tick_id);

        foreach ($datos as $row) {
            $usu_asig = $row["usu_asig"];
            $usu_crea = $row["usu_id"];
        }

        /* TODO: si Rol es 1 = Usuario insertar alerta para usuario soporte */
        if ($_SESSION["rol_id"] == 1) {
            /* TODO: Guardar Notificacion de nuevo Comentario */
            $sql0 = "INSERT INTO tm_notificacion (not_id,usu_id,not_mensaje,tick_id,est) VALUES (null, $usu_asig ,'Tiene una nueva respuesta del usuario con nro de ticket : ',$tick_id,2)";
            $sql0 = $conectar->prepare($sql0);
            $sql0->execute();
            /* TODO: Else Rol es = 2 Soporte Insertar alerta para usuario que genero el ticket */
        } else {
            /* TODO: Guardar Notificacion de nuevo Comentario */
            $sql0 = "INSERT INTO tm_notificacion (not_id,usu_id,not_mensaje,tick_id,est) VALUES (null,$usu_crea,'Tiene una nueva respuesta de soporte del ticket Nro : ',$tick_id,2)";
            $sql0 = $conectar->prepare($sql0);
            $sql0->execute();
        }

        $sql = "INSERT INTO td_ticketdetalle (tickd_id,tick_id,usu_id,tickd_descrip,fech_crea,est) VALUES (NULL,?,?,?,now(),'1');";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $tick_id);
        $sql->bindValue(2, $usu_id);
        $sql->bindValue(3, $tickd_descrip);
        $sql->execute();

        /* TODO: Devuelve el ultimo ID (Identty) ingresado */
        $sql1 = "select last_insert_id() as 'tickd_id';";
        $sql1 = $conectar->prepare($sql1);
        $sql1->execute();
        return $sql1->fetchAll(pdo::FETCH_ASSOC);
    }

    /* TODO: Insertar linea adicional de detalle al cerrar el ticket */
    public function insert_ticketdetalle_cerrar($tick_id, $usu_id)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "call sp_i_ticketdetalle_01(?,?)";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $tick_id);
        $sql->bindValue(2, $usu_id);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Insertar linea adicional al reabrir el ticket */
    public function insert_ticketdetalle_reabrir($tick_id, $usu_id)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "INSERT INTO td_ticketdetalle (tickd_id,tick_id,usu_id,tickd_descrip,fech_crea,est) 
                VALUES (NULL,?,?,'Ticket Re-Abierto...',now(),'1');";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $tick_id);
        $sql->bindValue(2, $usu_id);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: actualizar ticket */
    public function update_ticket($tick_id)
    {
        try {
            $conectar = parent::conexion();

            parent::set_names();

            $sql = "UPDATE tm_ticket 
                    set	
                        tick_estado = 'Cerrado',
                        fech_cierre = now()
                    where
                        tick_id = ?";

            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $tick_id);
            $sql->execute();

            $sql2 = "SELECT tm_tarea.id_tarea FROM tm_tarea WHERE tm_tarea.id_ticket = ?";

            $sql2 = $conectar->prepare($sql2);
            $sql2->bindValue(1, $tick_id);
            $sql2->execute();

            $resultado = $sql2->fetchAll();

            // Cerrar tareas al Cerrar ticket
            foreach ($resultado as $row) {
                $sql3 = "UPDATE tm_tarea SET 
                                tm_tarea.estado_tarea = 0,
                                tm_tarea.fecha_finalizacion = CURRENT_TIMESTAMP 
                            WHERE tm_tarea.id_tarea = ?";

                $sql3 = $conectar->prepare($sql3);
                $sql3->bindValue(1, $row['id_tarea']);
                $sql3->execute();
            }
        } catch (Exception $e) {
            return $e->getMessage();
        }

        return $resultado;
    }

    /* TODO:Cambiar estado del ticket al reabrir */
    public function reabrir_ticket($tick_id)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "UPDATE tm_ticket 
                set	
                    tick_estado = 'Abierto'
                where
                    tick_id = ?";

        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $tick_id);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO:Actualizar usu_asig con usuario de soporte asignado */
    public function update_ticket_asignacion($tick_id, $usu_asig)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "UPDATE tm_ticket 
                SET	
                    usu_asig = ?,
                    tick_estado = 'En proceso',
                    fech_asig = now()
                WHERE
                    tick_id = ?";

        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_asig);
        $sql->bindValue(2, $tick_id);
        $sql->execute();

        /* TODO: Guardar Notificacion en la tabla */
        $sql1 = "INSERT INTO tm_notificacion (not_id,usu_id,not_mensaje,tick_id,est) VALUES (null,?,'Se le ha asignado el ticket Nro : ',?,2)";

        $sql1 = $conectar->prepare($sql1);
        $sql1->bindValue(1, $usu_asig);
        $sql1->bindValue(2, $tick_id);
        $sql1->execute();

        return $sql->fetchAll();
    }

    /* TODO: Obtener total de tickets */
    public function get_ticket_total()
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket";

        $sql = $conectar->prepare($sql);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Total de ticket Abiertos */
    public function get_ticket_totalabierto()
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where tick_estado='Abierto'";

        $sql = $conectar->prepare($sql);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Total de ticket Cerrados */
    public function get_ticket_totalcerrado()
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where tick_estado='Cerrado'";

        $sql = $conectar->prepare($sql);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO:Total de ticket por categoria */
    public function get_ticket_grafico()
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "SELECT tm_categoria.cat_nom as nom,COUNT(*) AS total
                FROM   tm_ticket  JOIN  
                    tm_categoria ON tm_ticket.cat_id = tm_categoria.cat_id  
                WHERE    
                tm_ticket.est = 1
                GROUP BY 
                tm_categoria.cat_nom 
                ORDER BY total DESC";

        $sql = $conectar->prepare($sql);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Actualizar valor de estrellas de encuesta */
    public function insert_encuesta($tick_id, $tick_estre, $tick_comment)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "UPDATE tm_ticket 
                SET	
                    tick_estre = ?,
                    tick_coment = ?
                WHERE
                    tick_id = ?";

        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $tick_estre);
        $sql->bindValue(2, $tick_comment);
        $sql->bindValue(3, $tick_id);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Filtro Avanzado de ticket */
    public function filtrar_ticket($tick_titulo, $cat_id, $prio_id)
    {
        $conectar = parent::conexion();

        parent::set_names();

        $sql = "call filtrar_ticket (?,?,?)";

        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, "%" . $tick_titulo . "%");
        $sql->bindValue(2, $cat_id);
        $sql->bindValue(3, $prio_id);
        $sql->execute();

        return $sql->fetchAll();
    }

    public function reporte_mensual($fecha_inicio, $fecha_fin)
    {
        $conectar = parent::conexion();

        $sql = 'CALL reporte_mensual(?, ?)';

        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $fecha_inicio);
        $sql->bindValue(2, $fecha_fin);
        $sql->execute();

        $data = $sql->fetchAll(PDO::FETCH_ASSOC);

        $filename = 'reporte.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment;filename="' . $filename . '"');
        header('Cache-Control: max-age=0');

        $output = fopen('php://output', 'w');

        $columnHeaders = array_keys($data[0]);

        fputcsv($output, $columnHeaders);

        foreach ($data as $row) {
            fputcsv($output, $row);
        }

        fclose($output);

        exit;
    }
}
