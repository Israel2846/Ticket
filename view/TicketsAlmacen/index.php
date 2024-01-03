<?php

require_once("../../config/conexion.php");

if (isset($_SESSION["usu_id"])) :

?>

    <!DOCTYPE html>
    <html>
    <?php require_once("../MainHead/head.php"); ?>
    <title>Mis Ticket</title>
    </head>

    <body class="with-side-menu">

        <?php require_once("../MainHeader/header.php"); ?>

        <div class="mobile-menu-left-overlay"></div>

        <?php require_once("../MainNav/nav.php"); ?>

        <!-- Contenido -->
        <div class="page-content" id="recarga">

            <div class="container-fluid">

                <header class="section-header">
                    <div class="tbl">
                        <div class="tbl-row">
                            <div class="tbl-cell">
                                <h3>Tickets del almacén</h3>
                                <ol class="breadcrumb breadcrumb-simple">
                                    <li><a href="../Home/">Inicio</a></li>
                                    <li class="active">Tickets Almacén</li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </header>

                <div class="box-typical box-typical-padding">
                    <div class="row">
                        <div class="col-lg-12" id="ticketsAlmacen">
                            <fieldset class="form-group">
                                <table id="tickets_almacen" class="table table-bordered table-striped table-vcenter js-dataTable-full">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%;">#Ticket</th>
                                            <th style="width: 5%;">Categoria</th>
                                            <th class="d-none d-sm-table-cell" style="width: 5%;">Titulo</th>
                                            <th class="d-none d-sm-table-cell" style="width: 5%;">Prioridad</th>
                                            <th class="d-none d-sm-table-cell" style="width: 5%;">Estado</th>
                                            <th class="d-none d-sm-table-cell" style="width: 10%;">F. Creación</th>
                                            <th class="d-none d-sm-table-cell" style="width: 10%;">F. Asignación</th>
                                            <th class="d-none d-sm-table-cell" style="width: 5%;">T. Respuesta</th>
                                            <th class="d-none d-sm-table-cell" style="width: 5%;">T. Transcurrido</th>
                                            <th class="d-none d-sm-table-cell" style="width: 5%;">T. Total</th>
                                            <th class="d-none d-sm-table-cell" style="width: 10%;">F. Cierre</th>
                                            <th class="d-none d-sm-table-cell" style="width: 10%;">Creador</th>
                                            <th class="text-center" style="width: 5%;">Info</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                    </tbody>
                                </table>
                            </fieldset>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Contenido -->
        <?php require_once("../MainJs/js.php"); ?>

        <script type="text/javascript" src="ticketsAlmacen.js"></script>

        <script type="text/javascript" src="../notificacion.js"></script>

    </body>

    </html>

<?php
else :
    header("Location:" . Conectar::ruta() . "index.php");
endif
?>