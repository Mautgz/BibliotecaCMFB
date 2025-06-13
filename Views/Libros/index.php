<?php include "Views/Templates/header.php"; ?>
<div class="app-title">
    <div>
        <h1><i class="fa fa-dashboard"></i> Libros</h1>
    </div>
    <div>
        <button class="btn btn-primary mb-2" type="button" onclick="frmLibros()"><i class="fa fa-plus"></i></button>
        <button class="btn btn-success mb-2" type="button" onclick="importarExcel()"><i class="fa fa-file-excel-o"></i> Importar Excel</button>
        <a href="<?php echo base_url; ?>Plantillas/generarPlantillaLibros" class="btn btn-info mb-2">
            <i class="fas fa-download"></i> Descargar Plantilla
        </a>
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="tile">
            <div class="tile-body">
                <div class="table-responsive">
                    <table class="table table-light mt-4" id="tblLibros">
                        <thead class="thead-dark">
                            <tr>
                                <th>Id</th>
                                <th>Código Libro</th>
                                <th>Código Dewey</th>
                                <th>Título</th>
                                <th>Autor Personal</th>
                                <th>Autor Corporativo</th>
                                <th>Editorial</th>
                                <th>Lugar</th>
                                <th>Número de Páginas</th>
                                <th>Año Edición</th>
                                <th>Cantidad</th>
                                <th>Ubicación</th>
                                <th>Descripción</th>
                                <th>Foto</th>
                                <th>Materia</th>
                                <th>Estado</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="nuevoLibro" class="modal fade" role="dialog" aria-labelledby="my-modal-title" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="title">Registro Libro</h5>
                <button class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="frmLibro" class="row" onsubmit="registrarLibro(event)">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="titulo">Título</label>
                            <input type="hidden" id="id" name="id">
                            <input id="titulo" class="form-control" type="text" name="titulo" placeholder="Título del libro" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="autor_personal">Autor Personal</label>
                            <input id="autor_personal" class="form-control" type="text" name="autor_personal" placeholder="Autor Personal">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="autor_corporativo">Autor Corporativo</label>
                            <input id="autor_corporativo" class="form-control" type="text" name="autor_corporativo" placeholder="Autor Corporativo">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="editorial">Editorial</label>
                            <input id="editorial" class="form-control" type="text" name="editorial" placeholder="Editorial">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="materia">Materia</label>
                            <input id="materia" class="form-control" type="text" name="materia" placeholder="Materia">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="cantidad">Cantidad</label>
                            <input id="cantidad" class="form-control" type="number" name="cantidad" placeholder="Cantidad">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="num_pagina">Número de páginas</label>
                            <input id="num_pagina" class="form-control" type="number" name="num_pagina" placeholder="Número de páginas">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="anio_edicion">Año Edición</label>
                            <input id="anio_edicion" class="form-control" type="date" name="anio_edicion" value="<?php echo date("Y-m-d"); ?>">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="codigo_dewey">Código Dewey</label>
                            <input id="codigo_dewey" class="form-control" type="text" name="codigo_dewey" placeholder="Código Dewey">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="codigo_libro">Código Libro</label>
                            <input id="codigo_libro" class="form-control" type="text" name="codigo_libro" placeholder="Código Libro" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="ubicacion">Ubicación</label>
                            <input id="ubicacion" class="form-control" type="text" name="ubicacion" placeholder="Ubicación">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="lugar">Lugar</label>
                            <input id="lugar" class="form-control" type="text" name="lugar" placeholder="Lugar">
                        </div>
                    </div>
                    <div class="col-md-8">
                            <div class="form-group">
                                <label for="descripcion">Descripción</label>
                                <textarea id="descripcion" class="form-control" name="descripcion" rows="2" placeholder="Descripción"></textarea>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <label>Imagen</label>
                            <div class="card border-primary">
                                <div class="card-body">
                                    <input type="hidden" id="foto_actual" name="foto_actual">
                                    <label for="imagen" id="icon-image" class="btn btn-primary"><i class="fa fa-cloud-upload"></i></label>
                                    <span id="icon-cerrar"></span>
                                    <input id="imagen" class="d-none" type="file" name="imagen" onchange="preview(event)">
                                    <img class="img-thumbnail" id="img-preview" src="" width="150">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <button class="btn btn-primary" type="submit" id="btnAccion">Registrar</button>
                            <button class="btn btn-danger" data-dismiss="modal" type="button">Cancelar</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal para importar Excel -->
<div id="importarExcel" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="my-modal-title" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title text-white" id="title">Importar Libros desde Excel</h5>
                <button class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="frmImportarExcel" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="excel">Seleccionar archivo Excel</label>
                        <input type="file" class="form-control" id="excel" name="excel" accept=".xlsx, .xls" required>
                    </div>
                    <div class="form-group">
                        <button class="btn btn-success" type="submit" id="btnImportar">Importar</button>
                        <button class="btn btn-danger" type="button" data-dismiss="modal">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?php include "Views/Templates/footer.php"; ?>