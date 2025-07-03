<?php
// Renderizar solo la lista de libros y la paginación
?>
<div class="row">
<?php if (!empty($data['libros'])): ?>
    <?php foreach ($data['libros'] as $libro): ?>
        <div class="col-md-4">
            <div class="book-card mb-4">
                <div class="book-title"><?php echo htmlspecialchars($libro['titulo']); ?></div>
                <div class="book-info"><i class="fa fa-user"></i> <?php echo htmlspecialchars($libro['autor_personal']); ?></div>
                <div class="book-info"><i class="fa fa-building"></i> <?php echo htmlspecialchars($libro['editorial']); ?></div>
                <div class="book-info"><i class="fa fa-map-marker"></i> <?php echo !empty($libro['ubicacion']) ? htmlspecialchars($libro['ubicacion']) : 'No especificada'; ?></div>
                <div class="book-info"><i class="fa fa-book"></i> Dewey: <?php echo htmlspecialchars($libro['codigo_dewey']); ?></div>
                <button class="btn btn-primary btn-sm mt-2" data-toggle="modal" data-target="#detalleModal<?php echo $libro['id']; ?>">Ver detalles</button>
            </div>
        </div>
    <?php endforeach; ?>
<?php else: ?>
    <div class="col-12 no-results">
        <i class="fa fa-search"></i>
        <p>No se encontraron libros con los filtros seleccionados.</p>
    </div>
<?php endif; ?>
</div>

<!-- Modales específicos para cada libro -->
<?php if (!empty($data['libros'])): ?>
    <?php foreach ($data['libros'] as $libro): ?>
        <div class="modal fade" id="detalleModal<?php echo $libro['id']; ?>" tabindex="-1" aria-labelledby="detalleModalLabel<?php echo $libro['id']; ?>" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="detalleModalLabel<?php echo $libro['id']; ?>">Detalle del Libro</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-4">
                                <img src="<?php echo $data['base_url']; ?>Assets/img/libros/<?php echo !empty($libro['imagen']) ? $libro['imagen'] : 'logo.png'; ?>" 
                                     class="img-fluid rounded" 
                                     alt="<?php echo htmlspecialchars($libro['titulo']); ?>"
                                     style="max-height: 300px; object-fit: cover;">
                            </div>
                            <div class="col-md-8">
                                <h4 class="mb-3"><?php echo htmlspecialchars($libro['titulo']); ?></h4>
                                <div class="mb-2">
                                    <strong>Autor:</strong> <?php echo htmlspecialchars($libro['autor_personal'] ?? 'No especificado'); ?>
                                </div>
                                <div class="mb-2">
                                    <strong>Editorial:</strong> <?php echo htmlspecialchars($libro['editorial'] ?? 'No especificada'); ?>
                                </div>
                                <div class="mb-2">
                                    <strong>Año de edición:</strong> <?php echo !empty($libro['anio_edicion']) ? date('Y', strtotime($libro['anio_edicion'])) : 'No especificado'; ?>
                                </div>
                                <div class="mb-2">
                                    <strong>Clasificación Dewey:</strong> <?php echo htmlspecialchars($libro['codigo_dewey'] ?? 'No especificada'); ?>
                                </div>
                                <div class="mb-2">
                                    <strong>Ubicación:</strong> <?php echo htmlspecialchars($libro['ubicacion'] ?? 'No especificada'); ?>
                                </div>
                                <div class="mb-2">
                                    <strong>Lugar de publicación:</strong> <?php echo htmlspecialchars($libro['lugar'] ?? 'No especificado'); ?>
                                </div>
                                <?php if (!empty($libro['descripcion'])): ?>
                                <div class="mb-2">
                                    <strong>Descripción:</strong>
                                    <p class="mt-2"><?php echo htmlspecialchars($libro['descripcion']); ?></p>
                                </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
<?php endif; ?>

<!-- Paginación -->
<?php if ($data['total_pages'] > 1): ?>
<nav aria-label="Paginación de libros">
    <ul class="pagination justify-content-center">
        <?php for ($i = 1; $i <= $data['total_pages']; $i++): ?>
            <li class="page-item <?php echo ($i == $data['current_page']) ? 'active' : ''; ?>">
                <a class="page-link" href="#" onclick="cambiarPagina(<?php echo $i; ?>); return false;"> <?php echo $i; ?> </a>
            </li>
        <?php endfor; ?>
    </ul>
</nav>
<?php endif; ?>

<script>
function cambiarPagina(pagina) {
    const title = document.getElementById('searchTitle').value.trim();
    const author = document.getElementById('searchAuthor').value.trim();
    const dewey = document.getElementById('searchDewey').value;
    let url = window.location.pathname + '?ajax=1&page=' + pagina;
    const params = new URLSearchParams();
    if (title) params.append('title', title);
    if (author) params.append('author', author);
    if (dewey) params.append('dewey', dewey);
    if (params.toString()) {
        url += '&' + params.toString();
    }
    fetch(url)
        .then(response => response.text())
        .then(html => {
            document.getElementById('libros-container').innerHTML = html;
        });
}
</script> 