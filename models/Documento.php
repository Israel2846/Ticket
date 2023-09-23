<?php
    class Documento extends Conectar{
        /* TODO: Insertar registro  */
        public function insert_documento($tick_id,$doc_nom){
            $conectar= parent::conexion();
            /* consulta sql */
            $sql="INSERT INTO td_documento (doc_id,tick_id,doc_nom,fech_crea,est) VALUES (null,?,?,now(),1);";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1,$tick_id);
            $sql->bindParam(2,$doc_nom);
            $sql->execute();
        }

        // Insertar registro de documento de tareas
        public function insert_documento_tarea($id_tarea, $doc_nom){
            try {
                $conectar = parent::conexion();
                $sql = "INSERT INTO td_documento_tarea (id_tarea, nom_doc, fech_crea, est)
                        VALUES (?, ?, now(), 1)";
                $sql = $conectar -> prepare($sql);
                $sql -> bindParam(1, $id_tarea);
                $sql -> bindParam(2, $doc_nom);
                $sql -> execute();
                return true;
            } catch (Exception $e) {
                return $e -> getMessage();
            }
        }

        /* TODO: insertar documento detalle */
        public function insert_documento_detalle($tickd_id,$det_nom){
            $conectar= parent::conexion();
            /* consulta sql */
            $sql="INSERT INTO td_documento_detalle (det_id,tickd_id,det_nom,est) VALUES (null,?,?,1);";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1,$tickd_id);
            $sql->bindParam(2,$det_nom);
            $sql->execute();
        }

        // Insertar documentos de respuestas de tarea
        public function insert_documento_detalle_tarea($id_tarea,$nom_det){
            try {
                $conectar= parent::conexion();
                /* consulta sql */
                $sql="INSERT INTO td_documento_tarea_detalle(id_tarea, nom_det, est) VALUES(?, ?, 1)";
                $sql = $conectar->prepare($sql);
                $sql->bindParam(1,$id_tarea);
                $sql->bindParam(2,$nom_det);
                $sql->execute();
                return true;
            } catch (Exception $e) {
                return $e -> getMessage();
            }
        }

        /* TODO: Obtener Documento por Ticket */
        public function get_documento_x_ticket($tick_id){
            $conectar= parent::conexion();
            /* consulta sql */
            $sql="SELECT * FROM td_documento WHERE tick_id=?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1,$tick_id);
            $sql->execute();
            return $resultado = $sql->fetchAll(pdo::FETCH_ASSOC);
        }

        // Obtener documento por tarea
        public function get_documento_x_tarea($id_tarea){
            try {
                $conectar = parent::conexion();
                parent::set_names();
                $sql = "SELECT * FROM td_documento_tarea 
                        WHERE id_tarea = ?";
                $sql = $conectar -> prepare($sql);
                $sql -> bindParam(1, $id_tarea);
                $sql -> execute();
                return $sql -> fetchAll(PDO::FETCH_ASSOC);
            } catch (Exception $e) {
                return $e -> getMessage();
            }
        }

        /* TODO: Obtener Documento x detalle */
        public function get_documento_detalle_x_ticketd($tickd_id){
            $conectar= parent::conexion();
            /* consulta sql */
            $sql="SELECT * FROM td_documento_detalle WHERE tickd_id=?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1,$tickd_id);
            $sql->execute();
            return $resultado = $sql->fetchAll(pdo::FETCH_ASSOC);
        }
    }
?>