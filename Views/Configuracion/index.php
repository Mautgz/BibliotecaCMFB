<?php include "Views/Templates/header.php"; ?>
<div class="app-title">
    <div>
        <h1><i class="fa fa-dashboard"></i> Datos de la Empresa</h1>
    </div>
    <div>
        <a href="<?php echo base_url; ?>Carousel" class="btn btn-primary">
            <i class="fa fa-images"></i> Gestionar Carousel
        </a>
    </div>
</div>
<div class="row">
    <div class="col-lg-12">
        <div class="tile">
            <div class="tile-body">
                <form id="frmConfig" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="form-group">
                                <label for="nombre"><i class="fa fa-address-card" aria-hidden="true"></i> Nombre</label>
                                <input id="id" type="hidden" name="id" value="<?php echo $data['id']; ?>">
                                <input id="nombre" class="form-control" type="text" name="nombre" value="<?php echo $data['nombre']; ?>" required placeholder="Nombre">
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="form-group">
                                <label for="telefono"><i class="fa fa-phone-square" aria-hidden="true"></i> Teléfono</label>
                                <input id="telefono" class="form-control" type="text" name="telefono" value="<?php echo $data['telefono']; ?>" required placeholder="Teléfono">
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="form-group">
                                <label for="direccion"><i class="fa fa-home" aria-hidden="true"></i> Dirección</label>
                                <input id="direccion" class="form-control" type="text" name="direccion" value="<?php echo $data['direccion']; ?>" required placeholder="Dirección">
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="form-group">
                                <label for="correo"><i class="fa fa-envelope" aria-hidden="true"></i> Correo Electrónico</label>
                                <input id="correo" class="form-control" type="text" name="correo" value="<?php echo $data['correo']; ?>" required placeholder="Correo electrónico">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fa fa-picture-o" aria-hidden="true"></i> Logo</label>
                                <div class="card border-primary">
                                    <div class="card-body">
                                        <input type="hidden" id="foto_actual">
                                        <label for="imagen" id="icon-image" class="btn btn-primary"><i class="fa fa-cloud-upload"></i></label>
                                        <span id="icon-cerrar"></span>
                                        <input id="imagen" class="d-none" type="file" name="imagen" onchange="preview(event)">
                                        <img class="img-thumbnail" id="img-preview" src="<?php echo base_url; ?>Assets/img/<?php echo $data['foto']; ?>" width="200">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button class="btn btn-primary" type="submit" onclick="frmConfig(event)">Actualizar</button>
                </form>
            </div>
        </div>
    </div>
</div>
<?php include "Views/Templates/footer.php"; ?>

<!-- Sección de administración de FAQs -->
<div class="tile mt-4" style="margin-top: 100px !important; margin-left: 230px !important;">
    <div class="tile-body">
        <h3>Preguntas Frecuentes (FAQs)</h3>
        <div class="table-responsive">
            <table id="faqs-table" class="table table-bordered">
                <thead>
                    <tr>
                        <th>Pregunta</th>
                        <th>Respuesta</th>
                        <th>Patrón (opcional)</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <button class="btn btn-success" onclick="mostrarFormularioAgregarFaq()">Agregar FAQ</button>
    </div>
</div>
<!-- Formulario modal para agregar/editar FAQ -->
<div id="faq-form" style="display:none; background:#fff; border:1px solid #ccc; padding:20px; position:fixed; top:100px; left:35%; z-index:2000; box-shadow:0 4px 16px rgba(0,0,0,0.2);">
    <input type="hidden" id="faq-id">
    <div class="form-group">
        <label>Pregunta</label>
        <input type="text" id="faq-pregunta" class="form-control">
    </div>
    <div class="form-group">
        <label>Respuesta</label>
        <textarea id="faq-respuesta" class="form-control"></textarea>
    </div>
    <div class="form-group">
        <label>Patrón regex (opcional)</label>
        <input type="text" id="faq-patron" class="form-control">
        <small class="form-text text-muted">
            Si quieres que esta respuesta se active con varias frases, escribe aquí una <b>expresión regular</b>.<br>
            Ejemplo: <code>horario</code> o <code>pr[ée]stam[oa]s?</code><br>
            Si lo dejas vacío, solo se activará con la pregunta exacta.
        </small>
    </div>
    <button class="btn btn-primary" onclick="guardarFaq()">Guardar</button>
    <button class="btn btn-secondary" onclick="cerrarFormularioFaq()">Cancelar</button>
</div>

<script>
function cargarFaqs() {
    fetch('index.php?url=Configuracion/listarFaqs')
        .then(res => res.json())
        .then(faqs => {
            const tbody = document.querySelector('#faqs-table tbody');
            tbody.innerHTML = '';
            faqs.forEach(faq => {
                tbody.innerHTML += `
                  <tr>
                    <td>${faq.pregunta}</td>
                    <td>${faq.respuesta}</td>
                    <td>${faq.patron_regex || ''}</td>
                    <td>
                      <button class='btn btn-sm btn-info' onclick="editarFaq(${faq.id}, '${encodeURIComponent(faq.pregunta)}', '${encodeURIComponent(faq.respuesta)}', '${encodeURIComponent(faq.patron_regex || '')}')">Editar</button>
                      <button class='btn btn-sm btn-danger' onclick="eliminarFaq(${faq.id})">Eliminar</button>
                    </td>
                  </tr>
                `;
            });
        });
}
function mostrarFormularioAgregarFaq() {
    document.getElementById('faq-id').value = '';
    document.getElementById('faq-pregunta').value = '';
    document.getElementById('faq-respuesta').value = '';
    document.getElementById('faq-patron').value = '';
    document.getElementById('faq-form').style.display = 'block';
}
function cerrarFormularioFaq() {
    document.getElementById('faq-form').style.display = 'none';
}
function guardarFaq() {
    const id = document.getElementById('faq-id').value;
    const pregunta = document.getElementById('faq-pregunta').value;
    const respuesta = document.getElementById('faq-respuesta').value;
    const patron = document.getElementById('faq-patron').value;
    const formData = new FormData();
    formData.append('pregunta', pregunta);
    formData.append('respuesta', respuesta);
    formData.append('patron_regex', patron);
    let url = 'index.php?url=Configuracion/agregarFaq';
    if (id) {
        formData.append('id', id);
        url = 'index.php?url=Configuracion/editarFaq';
    }
    fetch(url, { method: 'POST', body: formData })
        .then(res => res.json())
        .then(() => {
            cerrarFormularioFaq();
            cargarFaqs();
        });
}
function editarFaq(id, pregunta, respuesta, patron) {
    document.getElementById('faq-id').value = id;
    document.getElementById('faq-pregunta').value = decodeURIComponent(pregunta);
    document.getElementById('faq-respuesta').value = decodeURIComponent(respuesta);
    document.getElementById('faq-patron').value = decodeURIComponent(patron);
    document.getElementById('faq-form').style.display = 'block';
}
function eliminarFaq(id) {
    if (!confirm('¿Seguro que deseas eliminar esta FAQ?')) return;
    const formData = new FormData();
    formData.append('id', id);
    fetch('index.php?url=Configuracion/eliminarFaq', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(() => cargarFaqs());
}
window.onload = function() {
    cargarFaqs();
};
</script>

