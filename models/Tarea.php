<?php
class Tarea extends Conectar{
    // Insertar registro
    public function insert_tarea($id_ticket, $tarea_titulo, $tarea_desc){
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "INSERT INTO tm_tarea(id_ticket, tarea_titulo, tarea_desc) VALUES(?, ?, ?);";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $id_ticket);
            $sql->bindValue(2, $tarea_titulo);
            $sql->bindValue(3, $tarea_desc);
            $sql->execute();
            return true;
        } catch (Exception $e) {
            echo "Error " . $e->getMessage();
            return false; 
        }
    }
    
    public function listar_tareas(){
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "SELECT * FROM tm_tarea";
        $sql = $conectar->prepare($sql);
        $sql->execute();
        return $sql->fetchAll();        
    }
}