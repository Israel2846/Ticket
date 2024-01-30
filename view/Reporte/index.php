<?php
require_once("../../config/conexion.php");

if (isset($_SESSION['usu_id'])) :
?>

    <!DOCTYPE html>
    <html>

    <head>
        <?php require_once("../MainHead/head.php"); ?>

        <title>Reporte Mensual</title>
    </head>

    <body class="with-side-menu">
        <?php require_once("../MainHeader/header.php"); ?>

        <div class="mobile-menu-left-overlay"></div>

        <?php require_once("../MainNav/nav.php"); ?>

        <div class="page-content">
            <div class="container-fluid">

                <header class="section-header">
                    <div class="tbl">
                        <div class="tbl-row">
                            <div class="tbl-cell">
                                <h3>Reporte Mensual</h3>
                                <ol class="breadcrumb breadcrumb-simple">
                                    <li><a href="../Home/">Inicio</a></li>
                                    <li class="active">Reporte Mensual</li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </header>

                <div class="box-typical box-typical-padding">
                    <p>Desde esta ventana podra generar reportes mensuales sobre los tickets.</p>

                    <div class="row">
                        <form action="../../controller/ticket.php?op=reporte_mensual" method="post">

                            <div class="col-lg-3">
                                <fieldset class="form-group">
                                    <label class="form-label semibold">Fecha de inicio</label>
                                    <input type="date" class="form-control" name="fecha_inicio">
                                </fieldset>
                            </div>

                            <div class="col-lg-3">
                                <fieldset class="form-group">
                                    <label class="form-label semibold">Fecha de finalización</label>
                                    <input type="date" class="form-control" name="fecha_fin">
                                </fieldset>
                            </div>

                            <div class="col-lg-12">
                                <fieldset class="form-group">
                                    <label class="form-label semibold"></label>
                                    <button type="submit" class="btn btn-rounded btn-inline btn-primary">Generar</button>
                                </fieldset>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </div>
    </body>

    </html>

<?php
else :
    header("Location:" . Conectar::ruta() . "index.php");
endif
?>