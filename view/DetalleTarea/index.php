<?php
require_once("../../config/conexion.php");
if (isset($_SESSION["usu_id"])) {
?>
  <!DOCTYPE html>
  <html>
  <?php require_once("../MainHead/head.php"); ?>
  <title>AnderCode</>::Detalle Tarea</title>
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
                <h3 id="lblnomidtarea"></h3>
                <div id="lblestado"></div>
                <span class="label label-pill label-primary" id="lblnomusuario"></span>
                <span class="label label-pill label-default" id="lblfechcrea"></span>
                <ol class="breadcrumb breadcrumb-simple">
                  <li><a href="#">Home</a></li>
                  <li class="active">Detalle Tareas</li>
                </ol>
              </div>
            </div>
          </div>
        </header>

        <div class="box-typical box-typical-padding">
          <div class="row">
              <div class="col-lg-6">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="tarea_titulo">Titulo</label>
                  <input type="text" class="form-control" id="tarea_titulo" name="tarea_titulo" readonly>
                </fieldset>
              </div>

              <div class="col-lg-6">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="id_ticket">Ticket al que pertenece</label>
                  <input type="text" class="form-control" id="id_ticket" name="id_ticket" readonly>
                </fieldset>
              </div>

              <div class="col-lg-12">
                <fieldset class="form-group">
                  <label class="form-label semibold" for="tarea_descripusu">Descripción</label>
                  <div class="summernote-theme-1">
                    <textarea id="tarea_descripusu" name="tarea_descripusu" class="summernote" name="name"></textarea>
                  </div>
                </fieldset>
              </div>
          </div>
        </div>

        <!-- Seccion de respuestas -->
        <section class="activity-line" id="pnlRespuestas">

        </section>

        <div class="box-typical box-typical-padding" id="lblRespuesta">
          <div class="row">
            <!-- Mensajes de respuesta o seguimiento -->
            <div class="col-lg-12" id="lblRespuesta">
              <fieldset class="form-group">
                <label class="form-label semibold">Respuesta</label>
                <div class="summernote-theme-1">
                  <textarea name="respTarea" id="respTarea" class="summernote"></textarea>
                </div>
              </fieldset>
            </div>
            <div class="col-lg-12">
              <button type="button" id="btnEnviar" class="btn btn-rounded btn-inline btn-primary">Enviar</button>
              <button type="button" id="btncerrartarea" class="btn btn-rounded btn-inline btn-warning">Cerrar Tarea</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Contenido -->

    <?php require_once("../MainJs/js.php"); ?>

    <script type="text/javascript" src="detalletarea.js"></script>

    <script type="text/javascript" src="../notificacion.js"></script>

  </body>

  </html>
<?php
} else {
  header("Location:" . Conectar::ruta() . "index.php");
}
?>