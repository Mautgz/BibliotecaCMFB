// ... existing code ...
// Función para abrir el modal de importación
function importarEstudiantes() {
    $('#modalImportar').modal('show');
}

$('#frmImportar').on('submit', function(e) {
    e.preventDefault();
    var formData = new FormData(this);
    
    $.ajax({
        url: base_url + 'Estudiantes/importarEstudiantes',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json',
        success: function(response) {
            if (response.status) {
                Swal.fire({
                    icon: 'success',
                    title: 'Éxito',
                    text: response.msg,
                    timer: 1500
                }).then(() => {
                    $('#modalImportar').modal('hide');
                    $('#tblEstudiantes').DataTable().ajax.reload();
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: response.msg
                });
            }
        },
        error: function(xhr, status, error) {
            let errorMsg = 'Error al importar los datos';
            try {
                const response = JSON.parse(xhr.responseText);
                errorMsg = response.msg || errorMsg;
            } catch (e) {
                console.error('Error parsing response:', e);
            }
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: errorMsg
            });
        }
    });
});
// ... existing code ...