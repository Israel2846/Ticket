<?php
class Tarea extends Conectar{
    // Insertar registro
    public function insert_tarea($id_usuario, $id_ticket, $tarea_titulo, $tarea_desc){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "INSERT INTO tm_tarea(id_ticket, id_usuario, tarea_titulo, tarea_desc) VALUES(?, ?, ?, ?);";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_ticket);
            $sql->bindValue(2, $id_usuario);
            $sql->bindValue(3, $tarea_titulo);
            $sql->bindValue(4, $tarea_desc);
            $sql->execute();

            // Obtenemos el ultimo registro que se insertó en la base de datos
            $sql2 = "SELECT last_insert_id() AS 'id_tarea'";
            $sql2 = $conectar -> prepare($sql2);
            $sql2 -> execute();

            // Retornamos el ultimo registro
            return $sql2 -> fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            return "Error " . $e->getMessage();            
        }
    }

    // Insertar detalle de tarea
    public function insert_respuesta_tarea($id_tarea, $id_usuario, $descripcion_tarea){
        try {
            $conectar = parent::conexion();
            parent::set_names();
    
            $sql = "INSERT INTO td_tareadetalle(
                        tarea_id,
                        usu_id,
                        tarea_desc,
                        fecha_crea,
                        est) 
                    VALUES (?,?,?, now(), 1)";

            $sql = $conectar->prepare($sql);
            $sql->bindParam(1, $id_tarea);
            $sql->bindParam(2, $id_usuario);
            $sql->bindParam(3, $descripcion_tarea);
            $sql->execute();

            // Obtenemos ultimo id insertado en la bd.
            $sql2 = "SELECT last_insert_id() AS 'id_tarea'";
            $sql2 = $conectar->prepare($sql2);
            $sql2->execute();

            // Retornamos el último id.
            return $sql2->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
    
    // Listar todas las tareas
    public function listar_tareas(){
        try{
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT
                        tm_tarea.id_tarea, 
                        tm_tarea.id_ticket, 
                        creador.usu_nom as usu_nom,
                        tm_tarea.fecha_creacion, 
                        tm_tarea.tarea_titulo, 
                        tm_tarea.tarea_desc, 
                        tm_tarea.fecha_finalizacion, 
                        tm_tarea.estado_tarea, 
                        CONCAT(
                            FLOOR(TIMESTAMPDIFF(MINUTE, tm_tarea.fecha_creacion, tm_tarea.fecha_finalizacion) / 1440), ' Días ',
                            FLOOR((TIMESTAMPDIFF(MINUTE, tm_tarea.fecha_creacion, tm_tarea.fecha_finalizacion) % 1440) / 60), ' Horas ',
                            (TIMESTAMPDIFF(MINUTE, tm_tarea.fecha_creacion, tm_tarea.fecha_finalizacion) % 60), ' Minutos '
                        ) AS tiempo_finalizacion
                    FROM tm_tarea
                    INNER JOIN tm_usuario AS creador ON tm_tarea.id_usuario = creador.usu_id";
            $sql = $conectar->prepare($sql);
            $sql->execute();
            return $sql->fetchAll();
        } catch(Exception $e){
            echo "Error " . $e->getMessage();
            return false; 
        }
    }

    // Listar solo las tareas por el id del ticket
    public function listar_tareas_x_ticket($id_ticket){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT fecha_creacion,
                        tm_tarea.id_tarea,
                        tm_tarea.tarea_titulo,
                        tm_tarea.tarea_desc,
                        tm_tarea.fecha_finalizacion,
                        tm_tarea.estado_tarea,
                        CONCAT(
                            FLOOR(TIMESTAMPDIFF(MINUTE, tm_tarea.fecha_creacion, tm_tarea.fecha_finalizacion) / 1440), ' Días ',
                            FLOOR((TIMESTAMPDIFF(MINUTE, tm_tarea.fecha_creacion, tm_tarea.fecha_finalizacion) % 1440) / 60), ' Horas ',
                            (TIMESTAMPDIFF(MINUTE, tm_tarea.fecha_creacion, tm_tarea.fecha_finalizacion) % 60), ' Minutos '
                        ) AS tiempo_finalizacion
                    FROM tm_tarea
                    WHERE tm_tarea.id_ticket = ?
                    ORDER BY tm_tarea.fecha_creacion DESC";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_ticket);
            $sql->execute();
            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Obtener solo una tarea
    public function get_tarea($id_tarea){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT *
                    FROM tm_tarea
                    INNER JOIN tm_usuario ON tm_tarea.id_usuario = tm_usuario.usu_id 
                    INNER JOIN tm_ticket on tm_ticket.tick_id = tm_tarea.id_ticket
                    where tm_tarea.id_tarea = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_tarea);
            $sql->execute();
            return $sql->fetch();
        } catch (Exception $e) {
            echo "Error: " . $e->getMessage();
            return false;
        }
    }

    // Listar respuestas de tareas
    public function listar_respuestas_tarea($id_tarea){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT
                        td_tareadetalle.tareadetalle_id,
                        td_tareadetalle.tarea_desc,
                        td_tareadetalle.fecha_crea,
                        tm_usuario.usu_nom,
                        tm_usuario.usu_ape,
                        tm_usuario.rol_id
                    FROM
                        td_tareadetalle
                    INNER JOIN tm_usuario ON td_tareadetalle.usu_id = tm_usuario.usu_id
                    WHERE td_tareadetalle.tarea_id = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1, $id_tarea);
            $sql->execute();
            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Asignar tarea
    public function assign_tarea($id_tarea, $id_usuario){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "UPDATE tm_tarea
                    SET id_usuario_asignado = ?, 	estado_tarea = 2
                    WHERE id_tarea = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_usuario);
            $sql->bindValue(2, $id_tarea);
            $sql->execute();
            return $sql->fetchAll();
        } catch (Exception $e) {
            echo "Error: " . $e->getMessage();
            return false;
        }
    }

    // Cerrar tarea
    public function close_tarea($id_tarea){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "UPDATE tm_tarea SET 
                        tm_tarea.estado_tarea = 0,
                        tm_tarea.fecha_finalizacion = CURRENT_TIMESTAMP 
                    WHERE tm_tarea.id_tarea = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_tarea);
            $sql->execute();
            $response = array("success" => true);
            echo json_encode($response);
        } catch (Exception $e) {
            echo "Error: " . $e->getMessage();
            return false;
        }
    }

    // Cerrar tarea mediante el mensaje modal
    public function close_tareas_x_modal($id_usuario){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "INSERT INTO td_pausas_ticket (td_pausas_ticket.id_ticket, td_pausas_ticket.id_usuario, td_pausas_ticket.fecha_pausa) 
                    VALUES ((SELECT tm_tarea.id_ticket FROM tm_tarea WHERE tm_tarea.estado_tarea = 1 AND tm_tarea.id_usuario = ? limit 1), ?, now())";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_usuario);
            $sql->bindValue(2, $id_usuario);
            $sql->execute();
            
            $sql2 = "UPDATE tm_tarea 
                    INNER JOIN tm_ticket ON tm_ticket.tick_id = tm_tarea.id_ticket
                    SET 
                        tm_tarea.estado_tarea = 0,
                        tm_tarea.fecha_finalizacion = CURRENT_TIMESTAMP ,
                        tm_ticket.tick_estado = 'Pausado'
                    WHERE tm_tarea.id_tarea = (
                            SELECT tm_tarea.id_tarea
                            FROM tm_tarea
                            WHERE tm_tarea.id_usuario = ? AND tm_tarea.estado_tarea = 1
                        )";
            $sql2 = $conectar->prepare($sql2);
            $sql2->bindValue(1, $id_usuario);
            $sql2->execute();

            echo true;
        } catch (Exception $e) {
            echo "Error: " . $e->getMessage();
            return false;
        }
    }

    // Contar tareas abiertas segun el id de usuario
    public function count_tareas_abiertas($id_usuario){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT COUNT(*) AS tareas_abiertas
                    FROM tm_tarea
                    WHERE tm_tarea.estado_tarea = 1 AND tm_tarea.id_usuario = ? ;";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_usuario);
            $sql->execute();
            return $sql->fetch();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    
}