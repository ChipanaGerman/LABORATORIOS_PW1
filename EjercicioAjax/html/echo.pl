#!/usr/bin/env perl

use strict;
use warnings;

print "Content-type: text/html\n\n";
print <<EOF;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Mascotas</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> <!-- Asegúrate de que esté cargando el JS de Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>Gestión de Mascotas</h2>
        <ul class="nav nav-tabs" id="tabs">
            <li class="active"><a href="#insertar" data-toggle="tab">Insertar</a></li>
            <li><a href="#eliminar" data-toggle="tab">Eliminar</a></li>
        </ul>
        <div class="tab-content">
            <!-- Formulario para insertar mascotas -->
            <div id="insertar" class="tab-pane fade in active">
                <h3>Insertar Mascota</h3>
                <form id="formInsertar" method="POST">
                    <div class="form-group">
                        <label for="nombre">Nombre:</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="form-group">
                        <label for="dueno">Dueño:</label>
                        <input type="text" class="form-control" id="dueno" name="dueno" required>
                    </div>
                    <div class="form-group">
                        <label for="especie">Especie:</label>
                        <input type="text" class="form-control" id="especie" name="especie" required>
                    </div>
                    <div class="form-group">
                        <label for="sexo">Sexo:</label>
                        <select class="form-control" id="sexo" name="sexo" required>
                            <option value="m">Macho</option>
                            <option value="f">Hembra</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="fecha_nacimiento">Fecha de Nacimiento:</label>
                        <input type="date" class="form-control" id="fecha_nacimiento" name="fecha_nacimiento" required>
                    </div>
                    <div class="form-group">
                        <label for="fecha_muerte">Fecha de Muerte:</label>
                        <input type="date" class="form-control" id="fecha_muerte" name="fecha_muerte">
                    </div>
                    <button type="button" class="btn btn-primary btn-action" id="submitNoAJAXInsertar">Insertar Sin AJAX</button>
                    <button type="button" class="btn btn-primary btn-action" id="submitAJAXInsertar">Insertar Con AJAX</button>
                </form>
                <div id="respInsertar" class="alert" style="display:none;"></div>
            </div>

            <!-- Formulario para eliminar mascotas -->
            <div id="eliminar" class="tab-pane fade">
                <h3>Eliminar Mascota</h3>
                <form id="formEliminar" method="POST">
                    <div class="form-group">
                        <label for="id_eliminar">ID Mascota:</label>
                        <input type="text" class="form-control" id="id_eliminar" name="id" required>
                    </div>
                    <button type="button" class="btn btn-danger btn-action" id="submitAJAXEliminar">Eliminar Con AJAX</button>
                </form>
                <div id="respEliminar" class="alert" style="display:none;"></div>
            </div>
        </div>
    </div>

    <script>
        \$(document).ready(function() {
            // Inicialización de las pestañas de Bootstrap
            \$('#tabs a').click(function(e) {
                e.preventDefault();
                \$(this).tab('show');
            });

            // Insertar mascota
            \$('#submitNoAJAXInsertar').click(function() {
                \$('#formInsertar').attr('action', 'myScript.pl').submit();
            });

            \$('#submitAJAXInsertar').click(function() {
                \$.post('myScriptAjax.pl', \$('#formInsertar').serialize(), function(response) {
                    \$('#respInsertar').removeClass("alert-danger").addClass("alert-success").html(response.message).show();
                }).fail(function() {
                    \$('#respInsertar').removeClass("alert-success").addClass("alert-danger").html("Error al insertar la mascota").show();
                });
            });

            // Eliminar mascota
            \$('#submitAJAXEliminar').click(function() {
                \$.post('deletePet.pl', \$('#formEliminar').serialize(), function(response) {
                    \$('#respEliminar').removeClass("alert-danger").addClass("alert-success").html(response.message).show();
                }).fail(function() {
                    \$('#respEliminar').removeClass("alert-success").addClass("alert-danger").html("Error al eliminar la mascota").show();
                });
            });
        });
    </script>
</body>
</html>
EOF
