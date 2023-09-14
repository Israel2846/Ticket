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
            return true;
        } catch (Exception $e) {
            echo "Error " . $e->getMessage();
            return false; 
        }
    }
    
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
                    WHERE tm_tarea.id_ticket = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_ticket);
            $sql->execute();
            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

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

    public function count_tareas_abiertas($id_usuario, $id_ticket){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT COUNT(*) AS tareas_abiertas
                    FROM tm_tarea
                    WHERE tm_tarea.estado_tarea = 1 AND tm_tarea.id_ticket = ? AND tm_tarea.id_usuario = ? ;";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_ticket);
            $sql->bindValue(2, $id_usuario);
            $sql->execute();
            return $sql->fetch();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    // Insertar detalle de tarea
    public function insert_tarea_detalle($id_tarea, $id_usuario, $descripcion_tarea){
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

            $sql2 = "SELECT last_insert_id() as 'tarea_detalle_id'";
            $sql2 = $conectar->prepare($sql2);
            $sql2->execute();
            return $sql2->fetchAll(pdo::FETCH_ASSOC);
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
}