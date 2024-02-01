<?php
class Usuario extends Conectar
{

    /* TODO: Funcion de login y generacion de session */
    public function login()
    {
        $conectar = parent::conexion();
        parent::set_names();
        if (isset($_POST["enviar"])) {
            $correo = $_POST["usu_correo"];
            $pass = $_POST["usu_pass"];
            $sql_rol = "SELECT tm_usuario.rol_id FROM tm_usuario where tm_usuario.usu_correo = ? or tm_usuario.num_colab = ? AND tm_usuario.usu_pass = MD5(?)";
            $sql_rol = $conectar->prepare($sql_rol);
            $sql_rol->bindParam(1, $correo);
            $sql_rol->bindParam(2, $correo);
            $sql_rol->bindParam(3, $pass);
            $sql_rol->execute();
            $resultado = $sql_rol->fetch();
            if (is_array($resultado) and count($resultado) > 0) {
                $rol = $resultado["rol_id"];
            }
            // $rol = $_POST["rol_id"];
            if (empty($correo) and empty($pass)) {
                header("Location:" . conectar::ruta() . "index.php?m=2");
                exit();
            } else {
                $sql = "SELECT * FROM tm_usuario INNER JOIN tm_usr_cat ON tm_usuario.usu_id = tm_usr_cat.usu_id WHERE (usu_correo= ? or num_colab = ?) and usu_pass=MD5(?) and tm_usuario.rol_id = ? and est=1";
                $stmt = $conectar->prepare($sql);
                $stmt->bindValue(1, $correo);
                $stmt->bindValue(2, $correo);
                $stmt->bindValue(3, $pass);
                $stmt->bindValue(4, $rol);
                $stmt->execute();
                $resultado = $stmt->fetch();
                if (is_array($resultado) and count($resultado) > 0) {
                    $_SESSION["usu_id"] = $resultado["usu_id"];
                    $_SESSION["usu_nom"] = $resultado["usu_nom"];
                    $_SESSION["usu_ape"] = $resultado["usu_ape"];
                    $_SESSION["rol_id"] = $resultado["rol_id"];
                    $_SESSION["cat_id"] = $resultado["cat_id"];
                    header("Location:" . Conectar::ruta() . "view/Home/");
                    exit();
                } else {
                    header("Location:" . Conectar::ruta() . "index.php?m=1");
                    exit();
                }
            }
        }
    }

    /* TODO:Insert */
    public function insert_usuario($usu_nom, $usu_ape, $num_colab, $usu_correo, $usu_pass, $usu_almacen, $usu_area, $rol_id, $usu_telf)
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "INSERT INTO tm_usuario (usu_id, usu_nom, usu_ape, usu_correo, usu_pass, usu_almacen, usu_area, rol_id, usu_telf, fech_crea, fech_modi, fech_elim, est, num_colab) VALUES (NULL,?,?,?,MD5(?),?,?,?,?,now(), NULL, NULL, '1', ?);";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_nom);
        $sql->bindValue(2, $usu_ape);
        $sql->bindValue(3, $usu_correo);
        $sql->bindValue(4, $usu_pass);
        $sql->bindValue(5, $usu_almacen);
        $sql->bindValue(6, $usu_area);
        $sql->bindValue(7, $rol_id);
        $sql->bindValue(8, $usu_telf);
        $sql->bindValue(9, $num_colab);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO:Update */
    public function update_usuario($usu_id, $usu_nom, $usu_ape, $num_colab, $usu_correo, $usu_pass, $usu_almacen, $usu_area, $rol_id, $usu_telf)
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "UPDATE tm_usuario set
                usu_nom = ?,
                usu_ape = ?,
                usu_correo = ?,
                usu_pass = md5(?),
                usu_almacen = ?,
                usu_area = ?,
                rol_id = ?,
                usu_telf = ?,
                num_colab = ?
                WHERE
                usu_id = ?";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_nom);
        $sql->bindValue(2, $usu_ape);
        $sql->bindValue(3, $usu_correo);
        $sql->bindValue(4, $usu_pass);
        $sql->bindValue(5, $usu_almacen);
        $sql->bindValue(6, $usu_area);
        $sql->bindValue(7, $rol_id);
        $sql->bindValue(8, $usu_telf);
        $sql->bindValue(9, $num_colab);
        $sql->bindValue(10, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO:Delete */
    public function delete_usuario($usu_id)
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "call sp_d_usuario_01(?)";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO:Todos los registros */
    public function get_usuario()
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "call sp_l_usuario_01()";
        $sql = $conectar->prepare($sql);
        $sql->execute();
        return $sql->fetchAll();
    }

    // Obtener usuarios de soporte
    public function get_usuario_soporte()
    {
        $conectar = parent::conexion();
        parent::set_names();

        $sql = "SELECT * FROM tm_usuario
                INNER JOIN tm_almacen ON 
                tm_usuario.usu_almacen = 
                tm_almacen.id_almacen
                INNER JOIN tm_area_almacen ON 
                tm_usuario.usu_area = 
                tm_area_almacen.id_area_almacen
                WHERE rol_id != 3;";
        $sql = $conectar->prepare($sql);
        $sql->execute();

        return $sql->fetchAll();
    }

    /* TODO: Obtener registros de usuarios segun rol 2 */
    public function get_usuario_x_rol()
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "SELECT * FROM tm_usuario where est=1 and rol_id=2";
        $sql = $conectar->prepare($sql);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO:Registro x id */
    public function get_usuario_x_id($usu_id)
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "call sp_l_usuario_02(?)";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO: Total de registros segun usu_id */
    public function get_usuario_total_x_id($usu_id, $usu_rol)
    {
        $conectar = parent::conexion();
        parent::set_names();
        switch ($usu_rol) {
            case 1:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_asig = ?";
                break;

            case 2:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_id = ?";
                break;

            case 3:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_id = ?";
                break;
        }
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO: Total de Tickets Abiertos por usu_id */
    public function get_usuario_totalabierto_x_id($usu_id, $usu_rol)
    {
        $conectar = parent::conexion();
        parent::set_names();
        switch ($usu_rol) {
            case 1:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_asig = ? and tick_estado='Abierto'";
                break;
            case 2:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_id = ? and tick_estado='Abierto'";
                break;
            case 3:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_id = ? and tick_estado='Abierto'";
                break;
        }
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO: Total de Tickets Cerrado por usu_id */
    public function get_usuario_totalcerrado_x_id($usu_id, $usu_rol)
    {
        $conectar = parent::conexion();
        parent::set_names();
        switch ($usu_rol) {
            case 1:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_asig = ? and tick_estado='Cerrado'";
                break;
            case 2:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_id = ? and tick_estado='Cerrado'";
                break;
            case 3:
                $sql = "SELECT COUNT(*) as TOTAL FROM tm_ticket where usu_id = ? and tick_estado='Cerrado'";
                break;
        }
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO: Total de Tickets por categoria segun usuario */
    public function get_usuario_grafico($usu_id, $usu_rol)
    {
        $conectar = parent::conexion();
        parent::set_names();
        if ($usu_rol == 1) {
            $sql = "SELECT tm_categoria.cat_nom as nom,COUNT(*) AS total
                FROM   tm_ticket  JOIN  
                    tm_categoria ON tm_ticket.cat_id = tm_categoria.cat_id  
                WHERE    
                tm_ticket.est = 1
                and tm_ticket.usu_asig = ?
                GROUP BY 
                tm_categoria.cat_nom 
                ORDER BY total DESC";
        } else {
            $sql = "SELECT tm_categoria.cat_nom as nom,COUNT(*) AS total
                FROM   tm_ticket  JOIN  
                    tm_categoria ON tm_ticket.cat_id = tm_categoria.cat_id  
                WHERE    
                tm_ticket.est = 1
                and tm_ticket.usu_id = ?
                GROUP BY 
                tm_categoria.cat_nom 
                ORDER BY total DESC";
        }
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    /* TODO: Actualizar contraseña del usuario */
    public function update_usuario_pass($usu_id, $usu_pass)
    {
        $conectar = parent::conexion();
        parent::set_names();
        $sql = "UPDATE tm_usuario
                SET
                    usu_pass = MD5(?)
                WHERE
                    usu_id = ?";
        $sql = $conectar->prepare($sql);
        $sql->bindValue(1, $usu_pass);
        $sql->bindValue(2, $usu_id);
        $sql->execute();
        return $resultado = $sql->fetchAll();
    }

    public function combo_almacen()
    {
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT * FROM tm_almacen";
            $sql = $conectar->prepare($sql);
            $sql->execute();
            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    public function combo_area($id_almacen)
    {
        try {
            $conectar = parent::conexion();
            parent::set_names();
            $sql = "SELECT * FROM tm_area_almacen WHERE tm_area_almacen.id_almacen = ?";
            $sql = $conectar->prepare($sql);
            $sql->bindParam(1, $id_almacen);
            $sql->execute();
            return $sql->fetchAll();
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }
}
