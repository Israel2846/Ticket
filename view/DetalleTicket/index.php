<?php
require_once("../../config/conexion.php");
if (isset($_SESSION["usu_id"])) {
?>
  <!DOCTYPE html>
  <html>
  <?php require_once("../MainHead/head.php"); ?>
  <title>Detalle Tickets</title>
  </head>

  <body class="with-side-menu">

    <?php require_once("../MainHeader/header.php"); ?>

    <div class="mobile-menu-left-overlay"></div>

    <?php require_once("../MainNav/nav.php"); ?>

    <!-- Contenido -->
    <div class="page-content">
      <div class="container-fluid">

        <header class="section-header">
          <div class="tbl">
            <div class="tbl-row">
              <div class="tbl-cell">
                <h3 id="lblnomidticket">Detalle Ticket - 1</h3>
                <div id="lblestado"></div>
                <span class="label label-pill label-primary" id="lblnomusuario"></span>
                <span class="label label-pill label-default" id="lblfechcrea"></span>
                <ol class="breadcrumb breadcrumb-simple">
                  <li><a href="../Home/">Inicio</a></li>
                  <li class="active">Detalle Tickets</li>
                </ol>
              </div>
            </div>
          </div>
        </header>

        <div class="box-typical box-typical-padding">
          <div class="row">

              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="tick_titulo">Titulo</label>
                  <input type="text" class="form-control" id="tick_titulo" name="tick_titulo" readonly>
                </fieldset>
              </div>

              <div class="col-lg-4">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="cat_nom">Categoria</label>
                  <input type="text" class="form-control" id="cat_nom" name="cat_nom" readonly>
                </fieldset>
              </div>

              <div class="col-lg-4">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="cat_nom">SubCategoria</label>
                  <input type="text" class="form-control" id="cats_nom" name="cats_nom" readonly>
                </fieldset>
              </div>

              <div class="col-lg-4">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="cat_nom">Prioridad</label>
                  <input type="text" class="form-control" id="prio_nom" name="prio_nom" readonly>
                </fieldset>
              </div>
              
              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="tickd_descripusu">Descripción</label>
                  <div class="summernote-theme-1">
                    <textarea id="tickd_descripusu" name="tickd_descripusu" class="summernote" name="name"></textarea>
                  </div>

                </fieldset>
              </div>

              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold">Documentos Adicionales</label>
                  <table id="documentos_data" class="table table-bordered table-striped table-vcenter js-dataTable-full">
                    <thead>
                      <tr>
                        <th style="width: 90%;">Nombre</th>
                        <th class="text-center" style="width: 10%;"></th>
                      </tr>
                    </thead>
                    <tbody>

                    </tbody>
                  </table>
                </fieldset>
              </div>


              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="tareas">Tareas</label>
                  <table id="tarea_data" class="table table-bordered table-striped table-vcenter js-dataTable-full">
                    <thead>
                      <tr>
                        <th style="width: 20%;">Título</th>
                        <th style="width: 20%;">Descripción</th>
                        <th style="width: 10%;">Estado</th>
                        <th class="d-none d-sm-table-cell" style="width: 10%;">Fecha de creación</th>
                        <th class="d-none d-sm-table-cell" style="width: 10%;">Fecha de finalización</th>
                        <th class="d-none d-sm-table-cell" style="width: 10%;">Tiempo de finalización</th>
                        <th class="d-none d-sm-table-cell" style="width: 10%;">Ver</th>
                      </tr>
                    </thead>
                    <tbody>

                    </tbody>
                  </table>
                </fieldset>
              </div>

              <div class="col-lg-12">
                <button type="button" id="btnNuevaTarea" class="btn btn-rounded btn-inline btn-primary">Nueva Tarea</button>
              </div>
          </div>



        </div>

        <section class="activity-line" id="lbldetalle">

        </section>

        <div class="box-typical box-typical-padding" id="pnldetalle">
          <p>
            Ingrese su duda o consulta
          </p>
          <div class="row">
              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="tickd_descrip">Descripción</label>
                  <div class="summernote-theme-1">
                    <textarea id="tickd_descrip" name="tickd_descrip" class="summernote" name="name"></textarea>
                  </div>
                </fieldset>
              </div>

              <!-- TODO: Agregar archivos adjuntos -->
              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="fileElem">Documentos Adicionales</label>
                  <input type="file" name="fileElem" id="fileElem" class="form-control" multiple>
                  <p style="color: red;" id="errorText"></p>
                </fieldset>
              </div>

              <div class="col-lg-12">
                <button type="button" id="btnenviar" class="btn btn-rounded btn-inline btn-success">Enviar</button>
                <button type="button" id="btnpausarticket" class="btn btn-rounded btn-inline btn-primary">Pausar Ticket</button>
                <button type="button" id="btnreanudarticket" class="btn btn-rounded btn-inline btn-warning">Reanudar Ticket</button>
                <button type="button" id="btncerrarticket" class="btn btn-rounded btn-inline btn-danger">Cerrar Ticket</button>
              </div>
          </div>
			  </div>

      </div>
    </div>
    <!-- Contenido -->

    <?php require_once("../MainJs/js.php"); ?>

    <script type="text/javascript" src="detalleticket.js"></script>

    <script type="text/javascript" src="../notificacion.js"></script>

  </body>

  </html>
<?php
} else {
  header("Location:" . Conectar::ruta() . "index.php");
}
?>