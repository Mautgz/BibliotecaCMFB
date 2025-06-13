<?php include "Views/Templates/header.php"; ?>

<!-- <?php // include "Views/Templates/nav.php"; ?> -->

<div class="app-content-carousel">
    <div class="app-content-header">
        <h1 class="app-content-headerText">Gestión del Carousel</h1>
        <button class="app-content-headerButton" id="btnNewCarouselItem">Nuevo Item</button>
    </div>
    <div class="app-content-actions">
        <input type="text" placeholder="Buscar..." class="search-input">
        <div class="app-content-actions-wrapper">
            <button class="action-button list active" title="List View">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-list"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
            </button>
        </div>
    </div>
    <div class="products-area-wrapper tableView">
        <div class="products-header">
            <div class="product-cell image">Imagen</div>
            <div class="product-cell">Título</div>
            <div class="product-cell">Descripción</div>
            <div class="product-cell">Botón</div>
            <div class="product-cell">Orden</div>
            <div class="product-cell">Acciones</div>
        </div>
        <div id="carouselItemsList"></div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="modalCarouselItem" tabindex="-1" aria-labelledby="modalCarouselItemLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalCarouselItemLabel">Nuevo Item del Carousel</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formCarouselItem" enctype="multipart/form-data">
                    <input type="hidden" id="idCarouselItem" name="id">
                    <div class="mb-3">
                        <label for="title" class="form-label">Título</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Descripción</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="button_text" class="form-label">Texto del Botón</label>
                                <input type="text" class="form-control" id="button_text" name="button_text">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="button_link" class="form-label">Enlace del Botón</label>
                                <input type="text" class="form-control" id="button_link" name="button_link">
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="image" class="form-label">Imagen</label>
                        <input type="file" class="form-control" id="image" name="image" accept="image/*">
                        <small class="form-text text-muted">Recomendado: 1920x1080px, formato JPG/PNG, peso menor a 1MB.</small>
                        <div id="previewImage" class="mt-2"></div>
                    </div>
                    <div class="mb-3">
                        <label for="order_number" class="form-label">Orden</label>
                        <input type="number" class="form-control" id="order_number" name="order_number" value="0" min="0">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" id="btnSaveCarouselItem">Guardar</button>
            </div>
        </div>
    </div>
</div>

<?php include "Views/Templates/footer.php"; ?>

<script>
    let carouselItems = [];
    const modalCarouselItem = new bootstrap.Modal(document.getElementById('modalCarouselItem'));
    const formCarouselItem = document.getElementById('formCarouselItem');
    const btnNewCarouselItem = document.getElementById('btnNewCarouselItem');
    const btnSaveCarouselItem = document.getElementById('btnSaveCarouselItem');
    const carouselItemsList = document.getElementById('carouselItemsList');

    document.addEventListener('DOMContentLoaded', function() {
        loadCarouselItems();
    });

    btnNewCarouselItem.addEventListener('click', function() {
        document.getElementById('idCarouselItem').value = '';
        formCarouselItem.reset();
        document.getElementById('previewImage').innerHTML = '';
        modalCarouselItem.show();
    });

    btnSaveCarouselItem.addEventListener('click', function() {
        const formData = new FormData(formCarouselItem);
        fetch(base_url + 'Carousel/setCarouselItem', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.status) {
                modalCarouselItem.hide();
                loadCarouselItems();
                Swal.fire({
                    icon: 'success',
                    title: 'Éxito',
                    text: 'Item guardado correctamente'
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Error al guardar el item'
                });
            }
        });
    });

    function loadCarouselItems() {
        fetch(base_url + 'Carousel/getCarouselItems')
        .then(response => response.json())
        .then(data => {
            carouselItems = data;
            renderCarouselItems();
        });
    }

    function renderCarouselItems() {
        carouselItemsList.innerHTML = '';
        carouselItems.forEach(item => {
            carouselItemsList.innerHTML += `
                <div class="products-row" data-id="${item.id}">
                    <div class="product-cell image">
                        <img src="${base_url}${item.image_path}" alt="${item.title}" style="width: 100px; height: 60px; object-fit: cover;">
                    </div>
                    <div class="product-cell">${item.title}</div>
                    <div class="product-cell">${item.description}</div>
                    <div class="product-cell">${item.button_text || '-'}</div>
                    <div class="product-cell">${item.order_number}</div>
                    <div class="product-cell">
                        <button class="btn btn-primary btn-sm" onclick="editCarouselItem(${item.id})">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="deleteCarouselItem(${item.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `;
        });
    }

    function editCarouselItem(id) {
        const item = carouselItems.find(item => item.id == id);
        if (item) {
            document.getElementById('idCarouselItem').value = item.id;
            document.getElementById('title').value = item.title;
            document.getElementById('description').value = item.description;
            document.getElementById('button_text').value = item.button_text || '';
            document.getElementById('button_link').value = item.button_link || '';
            document.getElementById('order_number').value = item.order_number;
            document.getElementById('previewImage').innerHTML = `
                <img src="${base_url}${item.image_path}" alt="Preview" style="max-width: 200px;">
            `;
            modalCarouselItem.show();
        }
    }

    function deleteCarouselItem(id) {
        Swal.fire({
            title: '¿Está seguro de eliminar este item?',
            text: "Esta acción no se puede revertir",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                const formData = new FormData();
                formData.append('id', id);
                fetch(base_url + 'Carousel/delCarouselItem', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status) {
                        loadCarouselItems();
                        Swal.fire({
                            icon: 'success',
                            title: 'Éxito',
                            text: 'Item eliminado correctamente'
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Error al eliminar el item'
                        });
                    }
                });
            }
        });
    }

    // Preview image before upload
    document.getElementById('image').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('previewImage').innerHTML = `
                    <img src="${e.target.result}" alt="Preview" style="max-width: 200px;">
                `;
            }
            reader.readAsDataURL(file);
        }
    });
</script> 