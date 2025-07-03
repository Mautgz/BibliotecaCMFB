let tblUsuarios, tblEst, tblMateria, tblAutor, tblEditorial, tblLibros, tblPrestar;
document.addEventListener("DOMContentLoaded", function(){
    document.querySelector("#modalPass").addEventListener("click", function () {
        document.querySelector('#frmCambiarPass').reset();
        $('#cambiarClave').modal('show');
    });
    const language = {
        "decimal": "",
        "emptyTable": "No hay información",
        "info": "Mostrando _START_ a _END_ de _TOTAL_ Entradas",
        "infoEmpty": "Mostrando 0 to 0 of 0 Entradas",
        "infoFiltered": "(Filtrado de _MAX_ total entradas)",
        "infoPostFix": "",
        "thousands": ",",
        "lengthMenu": "Mostrar _MENU_ Entradas",
        "loadingRecords": "Cargando...",
        "processing": "Procesando...",
        "search": "Buscar:",
        "zeroRecords": "Sin resultados encontrados",
        "paginate": {
            "first": "Primero",
            "last": "Ultimo",
            "next": "Siguiente",
            "previous": "Anterior"
        }

    }
    const  buttons = [{
                //Botón para Excel
                extend: 'excel',
                footer: true,
                title: 'Archivo',
                filename: 'Export_File',

                //Aquí es donde generas el botón personalizado
                text: '<button class="btn btn-success"><i class="fa fa-file-excel-o"></i></button>'
            },
            //Botón para PDF
            {
                extend: 'pdf',
                footer: true,
                title: 'Archivo PDF',
                filename: 'reporte',
                text: '<button class="btn btn-danger"><i class="fa fa-file-pdf-o"></i></button>'
            },
            //Botón para print
            {
                extend: 'print',
                footer: true,
                title: 'Reportes',
                filename: 'Export_File_print',
                text: '<button class="btn btn-info"><i class="fa fa-print"></i></button>'
            }
        ]
            
    tblUsuarios = $('#tblUsuarios').DataTable({
        ajax: {
            url: base_url + "Usuarios/listar",
            dataSrc: ''
        },
        columns: [
            {'data' : 'id'},
            {'data': 'usuario'},
            {'data': 'nombre'},
            {'data': 'estado'},
            {'data': 'acciones'}
        ],
        responsive: true,
        bDestroy: true,
        iDisplayLength: 10,
        order: [
            [0, "desc"]
        ],
        language,
        dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
            "<'row'<'col-sm-12'tr>>" +
            "<'row'<'col-sm-5'i><'col-sm-7'p>>",
        buttons
    });
    //Fin de la tabla usuarios
    tblEst = $('#tblEst').DataTable({
        ajax: {
            url: base_url + "Estudiantes/listar",
            dataSrc: ''
        },
        columns: [
            {'data': 'id'},
            {'data': 'codigo'},
            {'data': 'dni'},
            {'data': 'nombre'},
            {'data': 'año'},
            {'data': 'direccion'},
            {'data': 'telefono'},
            {'data': 'estado'},
            {'data': 'acciones'}
        ],
        language,
        dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
            "<'row'<'col-sm-12'tr>>" +
            "<'row'<'col-sm-5'i><'col-sm-7'p>>",
            buttons
    });
    //Fin de la tabla Estudiantes
    // tblMateria = $('#tblMateria').DataTable({
    //     ajax: {
    //         url: base_url + "Materia/listar",
    //         dataSrc: ''
    //     },
    //     columns: [
    //         {'data': 'id'},
    //         {'data': 'materia'},
    //         {'data': 'estado'},
    //         {'data': 'acciones'}
    //     ],
    //     language,
    //     dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
    //         "<'row'<'col-sm-12'tr>>" +
    //         "<'row'<'col-sm-5'i><'col-sm-7'p>>",
    //     buttons
    // });
    // $('.materia').select2({
    //     placeholder: 'Buscar Materia',
    //     minimumInputLength: 2,
    //     ajax: {
    //         url: base_url + 'Materia/buscarMateria',
    //         dataType: 'json',
    //         delay: 250,
    //         data: function (params) {
    //             return {
    //                 q: params.term
    //             };
    //         },
    //         processResults: function (data) {
    //             return {
    //                 results: data
    //             };
    //         },
    //         cache: true
    //     }
    // });
    // function frmMateria() {}
    // function registrarMateria(e) {}
    // function btnEditarMat(id) {}
    // function btnEliminarMat(id) {}
    // function btnReingresarMat(id) {}
    //Fin de la tabla Materias
    // tblAutor = $('#tblAutor').DataTable({
    //     ajax: {
    //         url: base_url + "Autor/listar",
    //         dataSrc: ''
    //     },
    //     columns: [
    //         {'data': 'id'},
    //         {'data': 'imagen'},
    //         {'data': 'autor'},
    //         {'data': 'libros'},
    //         {'data': 'estado'},
    //         {'data': 'acciones'}
    //     ],
    //     language,
    //     dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
    //         "<'row'<'col-sm-12'tr>>" +
    //         "<'row'<'col-sm-5'i><'col-sm-7'p>>",
    //     buttons
    // });
    //Fin de la tabla Autor
    /*
    tblEditorial= $('#tblEditorial').DataTable({
        ajax: {
            url: base_url + "Editorial/listar",
            dataSrc: ''
        },
        columns: [{
                'data': 'id'
            },
            {
                'data': 'editorial'
            },
            {
                'data': 'estado'
            },
            {
                'data': 'acciones'
            }
        ],
        language,
        dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
            "<'row'<'col-sm-12'tr>>" +
            "<'row'<'col-sm-5'i><'col-sm-7'p>>",
            buttons
    });
    //Fin de la tabla editorial
    */
    tblLibros = $('#tblLibros').DataTable({
        ajax: {
            url: base_url + "Libros/listar",
            dataSrc: ''
        },
        columns: [
            {'data': 'id'},
            {'data': 'codigo_libro'},
            {'data': 'codigo_dewey'},
            {'data': 'titulo'},
            {
                'data': 'autor_personal',
                'defaultContent': ''
            },
            {
                'data': 'autor_corporativo',
                'defaultContent': ''
            },
            {'data': 'editorial'},
            {'data': 'lugar'},
            {'data': 'num_pagina'},
            {
                'data': 'anio_edicion',
                'render': function(data) {
                    if (data) {
                        return data.substring(0, 4);
                    }
                    return '';
                }
            },
            {'data': 'cantidad'},
            {'data': 'ubicacion'},
            {'data': 'descripcion'},
            {'data': 'foto'},
            {'data': 'materia'},
            {'data': 'estado'},
            {'data': 'acciones'}
        ],
        language,
        dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
            "<'row'<'col-sm-12'tr>>" +
            "<'row'<'col-sm-5'i><'col-sm-7'p>>",
            buttons
    });
    //fin Libros
    tblPrestar = $('#tblPrestar').DataTable({
        ajax: {
            url: base_url + "Prestamos/listar",
            dataSrc: ''
        },
        columns: [{
                'data': 'id'
            },
            {
                'data': 'titulo'
            },
            {
                'data': 'nombre'
            },
            {
                'data': 'fecha_prestamo'
            },

            {
                'data': 'fecha_devolucion'
            },
            {
                'data': 'cantidad'
            },
            {
                'data': 'observacion'
            },
            {
                'data': 'estado'
            },
            {
                'data': 'acciones'
            }
        ],
        language,
        dom: "<'row'<'col-sm-4'l><'col-sm-4 text-center'B><'col-sm-4'f>>" +
            "<'row'<'col-sm-12'tr>>" +
            "<'row'<'col-sm-5'i><'col-sm-7'p>>",
        buttons,
        "resonsieve": true,
        "bDestroy": true,
        "iDisplayLength": 10,
        "order": [
            [0, "desc"]
        ]
    });
    $('.estudiante').select2({
        placeholder: 'Buscar Estudiante',
        minimumInputLength: 2,
        ajax: {
            url: base_url + 'Estudiantes/buscarEstudiante',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    est: params.term
                };
            },
            processResults: function (data) {
                return {
                    results: data
                };
            },
            cache: true
        }
    });
    $('.libro').select2({
        placeholder: 'Buscar Libro',
            minimumInputLength: 2,
            ajax: {
                url: base_url + 'Libros/buscarLibro',
                dataType: 'json',
                delay: 250,
                data: function (params) {
                    return {
                        lb: params.term
                    };
                },
                processResults: function (data) {
                    return {
                        results: data
                    };
                },
                cache: true
            }
    });
    // $('.autor').select2({
    //     placeholder: 'Buscar Autor',
    //     minimumInputLength: 2,
    //     ajax: {
    //         url: base_url + 'Autor/buscarAutor',
    //         dataType: 'json',
    //         delay: 250,
    //         data: function (params) {
    //             return {
    //                 est: params.term
    //             };
    //         },
    //         processResults: function (data) {
    //             return {
    //                 results: data
    //             };
    //         },
    //         cache: true
    //     }
    // });
    // ... existing code ...
    if (document.getElementById('nombre_estudiante')) {
        const http = new XMLHttpRequest();
        const url = base_url + 'Configuracion/verificar';
        http.open("GET", url);
        http.send();
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                let html = '';
                res.forEach(row => {
                    html += `
                    <a class="app-notification__item" href="javascript:;"><span class="app-notification__icon"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x text-primary"></i><i class="fa fa-user-o fa-stack-1x fa-inverse"></i></span></span>
                        <div>
                            <p class="app-notification__message" id="nombre_estudiante">${row.nombre}</p>
                            <p class="app-notification__meta" id="fecha_entrega">${row.fecha_devolucion}</p>
                        </div>
                    </a>
                    `;
                });
                document.getElementById('nombre_estudiante').innerHTML = html;
            }
        }
    }
})

function frmUsuario() {
    document.getElementById("title").textContent = "Nuevo Usuario";
    document.getElementById("btnAccion").textContent = "Registrar";
    document.getElementById("claves").classList.remove("d-none");
    document.getElementById("frmUsuario").reset();
    document.getElementById("id").value = "";
    $("#nuevo_usuario").modal("show");
}
function registrarUser(e) {
    e.preventDefault();
    const usuario = document.getElementById("usuario");
    const nombre = document.getElementById("nombre");
    const clave = document.getElementById("clave");
    const confirmar = document.getElementById("confirmar");
    if (usuario.value == "" || nombre.value == "") {
        alertas('Todo los campos son requeridos', 'warning');
    } else {
        const url = base_url + "Usuarios/registrar";
        const frm = document.getElementById("frmUsuario");
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(new FormData(frm));
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                $("#nuevo_usuario").modal("hide");
                frm.reset();
                tblUsuarios.ajax.reload();
                alertas(res.msg, res.icono);
            }
        }
    }
}
function btnEditarUser(id) {
    document.getElementById("title").textContent = "Actualizar usuario";
    document.getElementById("btnAccion").textContent = "Modificar";
    const url = base_url + "Usuarios/editar/"+id;
    const http = new XMLHttpRequest();
    http.open("GET", url, true);
    http.send();
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            const res = JSON.parse(this.responseText);
            document.getElementById("id").value = res.id;
            document.getElementById("usuario").value = res.usuario;
            document.getElementById("nombre").value = res.nombre;
            document.getElementById("claves").classList.add("d-none");
            $("#nuevo_usuario").modal("show");
        }
    }
}
function btnEliminarUser(id) {
    Swal.fire({
        title: 'Esta seguro de eliminar?',
        text: "El usuario no se eliminará de forma permanente, solo cambiará el estado a inactivo!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Usuarios/eliminar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblUsuarios.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }
            
        }
    })
}
function btnReingresarUser(id) {
    Swal.fire({
        title: 'Esta seguro de reingresar?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Usuarios/reingresar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblUsuarios.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }

        }
    })
}
//Fin Usuarios
function frmEstudiante() {
    document.getElementById("title").textContent = "Nuevo Estuadiante";
    document.getElementById("btnAccion").textContent = "Registrar";
    document.getElementById("frmEstudiante").reset();
    document.getElementById("id").value = "";
    $("#nuevoEstudiante").modal("show");
}

function registrarEstudiante(e) {
    e.preventDefault();
    const codigo = document.getElementById("codigo");
    const dni = document.getElementById("dni");
    const nombre = document.getElementById("nombre");
    const año = document.getElementById("año");
    const telefono = document.getElementById("telefono");
    const direccion = document.getElementById("direccion");
    if (codigo.value == "" || dni.value == "" || nombre.value == ""
    || telefono.value == "" || direccion.value == "" || año.value == "") {
        alertas('Todo los campos son requeridos', 'warning');
    } else {
        const url = base_url + "Estudiantes/registrar";
        const frm = document.getElementById("frmEstudiante");
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(new FormData(frm));
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                $("#nuevoEstudiante").modal("hide");
                frm.reset();
                tblEst.ajax.reload();
                alertas(res.msg, res.icono);
            }
        }
    }
}

function btnEditarEst(id) {
    document.getElementById("title").textContent = "Actualizar estudiante";
    document.getElementById("btnAccion").textContent = "Modificar";
    const url = base_url + "Estudiantes/editar/" + id;
    const http = new XMLHttpRequest();
    http.open("GET", url, true);
    http.send();
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            const res = JSON.parse(this.responseText);
            document.getElementById("id").value = res.id;
            document.getElementById("codigo").value = res.codigo;
            document.getElementById("dni").value = res.dni;
            document.getElementById("nombre").value = res.nombre;
            document.getElementById("año").value = res.año;
            document.getElementById("telefono").value = res.telefono;
            document.getElementById("direccion").value = res.direccion;
            $("#nuevoEstudiante").modal("show");
        }
    }
}

function btnEliminarEst(id) {
    Swal.fire({
        title: 'Esta seguro de eliminar?',
        text: "El estudiante no se eliminará de forma permanente, solo cambiará el estado a inactivo!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Estudiantes/eliminar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblEst.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }

        }
    })
}

function btnReingresarEst(id) {
    Swal.fire({
        title: 'Esta seguro de reingresar?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Estudiantes/reingresar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblEst.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }

        }
    })
}

function btnEliminarDefinitivoEst(id) {
    Swal.fire({
        title: '¿Eliminar permanentemente?',
        text: "Esta acción no se puede deshacer.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Estudiantes/eliminarDefinitivo/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    try {
                        const res = JSON.parse(this.responseText);
                        tblEst.ajax.reload();
                        Swal.fire(res.msg, '', res.icono);
                    } catch (e) {
                        Swal.fire('No se puede borrar porque el estudiante tiene préstamos', '', 'warning');
                    }
                }
            }
        }
    });
}
//Fin Estudiante
// function frmMateria() {}
// function registrarMateria(e) {}
// function btnEditarMat(id) {}
// function btnEliminarMat(id) {}
// function btnReingresarMat(id) {}
//Fin Materia
// function frmAutor() {}
// function registrarAutor(e) {}
// function btnEditarAutor(id) {}
// function btnEliminarAutor(id) {}
// function btnReingresarAutor(id) {}
// $('.autor').select2({
//     placeholder: 'Buscar Autor',
//     minimumInputLength: 2,
//     ajax: {
//         url: base_url + 'Autor/buscarAutor',
//         dataType: 'json',
//         delay: 250,
//         data: function (params) {
//             return {
//                 est: params.term
//             };
//         },
//         processResults: function (data) {
//             return {
//                 results: data
//             };
//         },
//         cache: true
//     }
// });
// ... existing code ...
function frmLibros() {
    document.getElementById("title").textContent = "Nuevo Libro";
    document.getElementById("btnAccion").textContent = "Registrar";
    document.getElementById("frmLibro").reset();
    document.getElementById("id").value = "";
    $("#nuevoLibro").modal("show");
    deleteImg();
}

function registrarLibro(e) {
    e.preventDefault();
    const titulo = document.getElementById("titulo");
    const autor_personal = document.getElementById("autor_personal");
    const autor_corporativo = document.getElementById("autor_corporativo");
    const editorial = document.getElementById("editorial");
    const materia = document.getElementById("materia");
    const cantidad = document.getElementById("cantidad");
    const num_pagina = document.getElementById("num_pagina");

    if (titulo.value == '' || editorial.value == ''
    || materia.value == '' || cantidad.value == '' || num_pagina.value == '') {
        alertas('Todo los campos son requeridos', 'warning');
    } else {
        const url = base_url + "Libros/registrar";
        const frm = document.getElementById("frmLibro");
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(new FormData(frm));
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                $("#nuevoLibro").modal("hide");
                tblLibros.ajax.reload();
                frm.reset();
                alertas(res.msg, res.icono);
            }
        }
    }
}

function btnEditarLibro(id) {
    document.getElementById("title").textContent = "Actualizar Libro";
    document.getElementById("btnAccion").textContent = "Modificar";
    const url = base_url + "Libros/editar/" + id;
    const http = new XMLHttpRequest();
    http.open("GET", url, true);
    http.send();
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            const res = JSON.parse(this.responseText);
              document.getElementById("id").value = res.id;
              document.getElementById("titulo").value = res.titulo;
            document.getElementById("autor_personal").value = res.autor_personal;
            document.getElementById("autor_corporativo").value = res.autor_corporativo;
            document.getElementById("editorial").value = res.editorial;
            document.getElementById("materia").value = res.materia;
              document.getElementById("cantidad").value = res.cantidad;
              document.getElementById("num_pagina").value = res.num_pagina;
              document.getElementById("anio_edicion").value = res.anio_edicion;
              document.getElementById("descripcion").value = res.descripcion;
            document.getElementById("codigo_dewey").value = res.codigo_dewey;
            document.getElementById("codigo_libro").value = res.codigo_libro;
            document.getElementById("ubicacion").value = res.ubicacion;
            document.getElementById("lugar").value = res.lugar;
            document.getElementById("img-preview").src = base_url + 'Assets/img/libros/'+ res.imagen;
            document.getElementById("icon-cerrar").innerHTML = `
            <button class="btn btn-danger" onclick="deleteImg()">
            <i class="fa fa-times-circle"></i></button>`;
            document.getElementById("icon-image").classList.add("d-none");
            document.getElementById("foto_actual").value = res.imagen;
            $("#nuevoLibro").modal("show");
        }
    }
}

function btnEliminarLibro(id) {
    Swal.fire({
        title: 'Esta seguro de eliminar?',
        text: "El libro no se eliminará de forma permanente, solo cambiará el estado a inactivo!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Libros/eliminar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblLibros.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }

        }
    })
}

function btnReingresarLibro(id) {
    Swal.fire({
        title: 'Esta seguro de reingresar?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Libros/reingresar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblLibros.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }

        }
    })
}
function preview(e) {
    var input = document.getElementById('imagen');
    var filePath = input.value;
    var extension = /(\.png|\.jpeg|\.jpg)$/i;
    if (!extension.exec(filePath)) {
        alertas('Seleccione un archivo valido', 'warning');
        deleteImg();
        return false;
    }else{
        const url = e.target.files[0];
        const urlTmp = URL.createObjectURL(url);
        document.getElementById("img-preview").src = urlTmp;
        document.getElementById("icon-image").classList.add("d-none");
        document.getElementById("icon-cerrar").innerHTML = `
        <button class="btn btn-danger" onclick="deleteImg()"><i class="fa fa-times-circle"></i></button>
        `;
    }

}
function deleteImg() {
    document.getElementById("icon-cerrar").innerHTML = '';
    document.getElementById("icon-image").classList.remove("d-none");
    document.getElementById("img-preview").src = '';
    document.getElementById("imagen").value = '';
    document.getElementById("foto_actual").value = '';
}
function frmConfig(e) {
    e.preventDefault();
    const nombre = document.getElementById("nombre");
    const telefono = document.getElementById("telefono");
    const direccion = document.getElementById("direccion");
    const correo = document.getElementById("correo");
    if (nombre.value == "" || telefono.value == "" || direccion.value == "" || correo.value == "") {
        alertas('Todo los campos son requeridos', 'warning');
    } else {
        const url = base_url + "Configuracion/actualizar";
        const frm = document.getElementById("frmConfig");
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(new FormData(frm));
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                alertas(res.msg, res.icono);
            }
        }
    }
}
function frmPrestar() {
    document.getElementById("frmPrestar").reset();
    $("#prestar").modal("show");
}
function btnEntregar(id) {
    Swal.fire({
        title: 'Recibir de libro?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si!',
        cancelButtonText: 'No'
    }).then((result) => {
        if (result.isConfirmed) {
            const url = base_url + "Prestamos/entregar/" + id;
            const http = new XMLHttpRequest();
            http.open("GET", url, true);
            http.send();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    tblPrestar.ajax.reload();
                    alertas(res.msg, res.icono);
                }
            }

        }
    })
}
function registroPrestamos(e){
    e.preventDefault();
    const libro = document.getElementById("libro").value;
    const estudiante = document.getElementById("estudiante").value;
    const cantidad = document.getElementById("cantidad").value;
    const fecha_prestamo = document.getElementById("fecha_prestamo").value;
    const fecha_devolucion = document.getElementById("fecha_devolucion").value;
    if (libro == '' || estudiante == '' || cantidad == '' || fecha_prestamo == '' || fecha_devolucion == '') {
        alertas('Todo los campos son requeridos', 'warning');
    } else {
        const frm = document.getElementById("frmPrestar");
        const url = base_url + "Prestamos/registrar";
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(new FormData(frm));
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                tblPrestar.ajax.reload();
                $("#prestar").modal("hide");
                alertas(res.msg, res.icono);
                if (res.icono == 'success') {
                    setTimeout(() => {
                        window.open(base_url + 'Prestamos/ticked/'+ res.id, '_blank');
                    }, 3000);
                }
                
            }
        }
    }
}
function btnRolesUser(id) {
    const http = new XMLHttpRequest();
    const url = base_url + "Usuarios/permisos/" + id;
    http.open("GET", url);
    http.send();
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            document.getElementById("frmPermisos").innerHTML = this.responseText;
            $("#permisos").modal("show");
        }
    }
}
function registrarPermisos(e) {
    e.preventDefault();
    const http = new XMLHttpRequest();
    const frm = document.getElementById("frmPermisos");
    const url = base_url + "Usuarios/registrarPermisos";
    http.open("POST", url);
    http.send(new FormData(frm));
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            const res = JSON.parse(this.responseText);
            $("#permisos").modal("hide");
            if(res == 'ok'){
				alertas('Permisos Asignado', 'success');
			}else{
				alertas('Error al asignar los permisos', 'error');
			}
        }
    }
}
function modificarClave(e) {
    e.preventDefault();
    var formClave = document.querySelector("#frmCambiarPass");
    formClave.onsubmit = function (e) {
        e.preventDefault();
        const clave_actual = document.querySelector("#clave_actual").value;
        const nueva_clave = document.querySelector("#clave_nueva").value;
        const confirmar_clave = document.querySelector("#clave_confirmar").value;
        if (clave_actual == "" || nueva_clave == "" || confirmar_clave == "") {
            alertas('Todo los campos son requeridos', 'warning');
        } else if (nueva_clave != confirmar_clave) {
            alertas('Las contraseñas no coinciden', 'warning');
        } else {
            const http = new XMLHttpRequest();
            const frm = document.getElementById("frmPermisos");
            const url = base_url + "Usuarios/cambiarPas";
            http.open("POST", url);
            http.send(new FormData(formClave));
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    const res = JSON.parse(this.responseText);
                    $('#cambiarClave').modal("hide");
                    alertas(res.msg, res.icono);                    
                }
            }            
        }

    }
}
if (document.getElementById("reportePrestamo")) {
    const url = base_url + "Configuracion/grafico";
    const http = new XMLHttpRequest();
    http.open("GET", url, true);
    http.send();
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            try {
                const data = JSON.parse(this.responseText);
                let materias = [];
                let cantidad = [];
                let prestamosDevueltos = 0;
                let prestamosPendientes = 0;

                // Procesar datos para materias y estado de préstamos
                data.forEach(item => {
                    if (item.tipo === 'materia') {
                        materias.push(item.nombre);
                        cantidad.push(item.cantidad);
                    } else if (item.tipo === 'prestamo') {
                        if (item.estado === 'Devuelto') {
                            prestamosDevueltos = item.cantidad;
                        } else {
                            prestamosPendientes = item.cantidad;
                        }
                    }
                });

                // Gráfico de materias
                var ctxMaterias = document.getElementById("reportePrestamo");
                if (ctxMaterias) {
                    var myBarChart = new Chart(ctxMaterias, {
                    type: 'bar',
                    data: {
                            labels: materias,
                        datasets: [{
                                label: 'Libros por Materia',
                            data: cantidad,
                                backgroundColor: '#dc143c',
                        }],
                    },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true
                                }
                            }
                        }
                    });
                }

                // Gráfico de estado de préstamos
                var ctxPrestamos = document.getElementById("reportePrestamos");
                if (ctxPrestamos) {
                    var myPieChart = new Chart(ctxPrestamos, {
                        type: 'pie',
                        data: {
                            labels: ['Devueltos', 'Pendientes'],
                            datasets: [{
                                data: [prestamosDevueltos, prestamosPendientes],
                                backgroundColor: ['#28a745', '#dc3545'],
                            }],
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                },
                                title: {
                                    display: true,
                                    text: 'Estado de Préstamos'
                                }
                            }
                        }
                    });
                }
            } catch (error) {
                console.error('Error al procesar los datos:', error);
                alertas('Error al cargar los gráficos', 'error');
            }
        }
    }
}
function alertas(msg, icono) {
    Swal.fire({
        position: 'top-end',
        icon: icono,
        title: msg,
        showConfirmButton: false,
        timer: 3000
    })
}
function verificarLibro(e) {
    const libro = document.getElementById('libro').value;
    const cant = document.getElementById('cantidad').value;
    const http = new XMLHttpRequest();
    const url = base_url + 'Libros/verificar/' + libro;
    http.open("GET", url);
    http.send();
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            const res = JSON.parse(this.responseText);
            if (res.icono == 'success') {
                document.getElementById('msg_error').innerHTML = `<span class="badge badge-primary">Disponible: ${res.cantidad}</span>`;
            }else{
                alertas(res.msg, res.icono);
                return false;
            }
        }
    }
}
function importarExcel() {
    const input = document.getElementById('inputExcelEst');
    if (input.files.length > 0) {
        const formData = new FormData();
        formData.append('excel', input.files[0]);
        const url = base_url + "Estudiantes/importarExcel";
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(formData);
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                Swal.fire({
                    title: 'Importación de Estudiantes',
                    text: res.msg,
                    icon: res.icono,
                    confirmButtonText: 'Aceptar'
                });
                tblEst.ajax.reload();
                input.value = '';
            }
        }
    } else {
        Swal.fire('Selecciona un archivo Excel antes de importar.', '', 'warning');
    }
}

const frmImportarExcel = document.getElementById("frmImportarExcel");
if (frmImportarExcel) {
    frmImportarExcel.addEventListener("submit", function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        const url = base_url + "Libros/importarExcel";
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.send(formData);
        http.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                try {
                    const res = JSON.parse(this.responseText);
                    $("#importarExcel").modal("hide");
                    tblLibros.ajax.reload();
                    Swal.fire({
                        position: 'top-end',
                        icon: res.icono,
                        title: res.msg,
                        showConfirmButton: false,
                        timer: 3000
                    });
                } catch (error) {
                    console.error('Error al procesar la respuesta:', error);
                    alertas('Error al procesar la respuesta del servidor', 'error');
                }
            }
        }
    });
}

function buscarPorFecha() {
    const fecha_inicio = document.getElementById('fecha_inicio').value;
    const fecha_fin = document.getElementById('fecha_fin').value;
    if (fecha_inicio === '' || fecha_fin === '') {
        alert('Selecciona ambas fechas');
        return;
    }
    $.ajax({
        url: base_url + 'Prestamos/buscarPorFecha',
        type: 'POST',
        data: { fecha_inicio, fecha_fin },
        dataType: 'json',
        success: function(data) {
            tblPrestar.clear().rows.add(data).draw();
        }
    });
}

document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("formImportarEstudiantes");
    if (form) {
        form.addEventListener("submit", function(e) {
            e.preventDefault();
            const input = document.getElementById('inputExcelEst');
            if (input.files.length > 0) {
                const formData = new FormData();
                formData.append('excel', input.files[0]);
                const url = base_url + "Estudiantes/importarExcel";
                const http = new XMLHttpRequest();
                http.open("POST", url, true);
                http.send(formData);
                http.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        const res = JSON.parse(this.responseText);
                        Swal.fire({
                            title: 'Importación de Estudiantes',
                            text: res.msg,
                            icon: res.icono,
                            confirmButtonText: 'Aceptar'
                        });
                        tblEst.ajax.reload();
                        input.value = '';
                    }
                }
            } else {
                Swal.fire('Selecciona un archivo Excel antes de importar.', '', 'warning');
            }
        });
    }
});

function buscarPorFecha() {
    const fecha = document.getElementById("fecha").value;
    if (fecha == '') {
        alertas('Seleccione una fecha', 'warning');
    } else {
        const url = base_url + "Prestamos/buscarPorFecha";
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.send("fecha=" + fecha);
        http.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                const res = JSON.parse(this.responseText);
                if (res.length > 0) {
                    let html = '';
                    res.forEach(prestamo => {
                        html += `
                        <tr>
                            <td>${prestamo.nombre} ${prestamo.apellido}</td>
                            <td>${prestamo.titulo}</td>
                            <td>${prestamo.fecha_prestamo}</td>
                            <td>${prestamo.fecha_devolucion}</td>
                            <td>${prestamo.estado}</td>
                        </tr>
                        `;
                    });
                    document.getElementById("tblPrestamos").innerHTML = html;
                } else {
                    document.getElementById("tblPrestamos").innerHTML = '<tr><td colspan="5" class="text-center">No hay préstamos para esta fecha</td></tr>';
                }
            }
        }
    }
}

// ========== FUNCIONES PARA ESCÁNER ISBN Y TÍTULO ==========

function escanearLibro() {
    document.getElementById("isbn_input").value = "";
    document.getElementById("titulo_input").value = "";
    document.getElementById("resultado_busqueda").style.display = "none";
    document.getElementById("sin_resultados").style.display = "none";
    document.getElementById("camara_container").style.display = "none";
    document.getElementById("modo_busqueda").value = "isbn";
    alternarModoBusqueda();
    $("#escanearLibro").modal("show");
    document.getElementById("isbn_input").focus();
}

function alternarModoBusqueda() {
    const modo = document.getElementById("modo_busqueda").value;
    if (modo === "isbn") {
        document.getElementById("isbn_group").style.display = "block";
        document.getElementById("titulo_group").style.display = "none";
        document.getElementById("btn_buscar_isbn").style.display = "inline-block";
        document.getElementById("btn_buscar_titulo").style.display = "none";
        document.getElementById("isbn_input").focus();
    } else {
        document.getElementById("isbn_group").style.display = "none";
        document.getElementById("titulo_group").style.display = "block";
        document.getElementById("btn_buscar_isbn").style.display = "none";
        document.getElementById("btn_buscar_titulo").style.display = "inline-block";
        document.getElementById("titulo_input").focus();
    }
}

function buscarPorISBN() {
    const isbn = document.getElementById("isbn_input").value.trim();
    if (isbn === '') {
        alertas('Por favor ingrese un ISBN', 'warning');
        return;
    }
    document.getElementById("resultado_busqueda").style.display = "none";
    document.getElementById("sin_resultados").style.display = "none";
    const url = base_url + "Libros/buscarPorISBN";
    const http = new XMLHttpRequest();
    http.open("POST", url, true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("isbn=" + encodeURIComponent(isbn));
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            try {
                const res = JSON.parse(this.responseText);
                if (res.success) {
                    mostrarResultadoBusqueda(res.data);
                } else {
                    document.getElementById("sin_resultados").style.display = "block";
                }
            } catch (e) {
                document.getElementById("sin_resultados").style.display = "block";
            }
        }
    }
}

function buscarPorTitulo() {
    const titulo = document.getElementById("titulo_input").value.trim();
    if (titulo === '') {
        alertas('Por favor ingrese un título', 'warning');
        return;
    }
    document.getElementById("resultado_busqueda").style.display = "none";
    document.getElementById("sin_resultados").style.display = "none";
    const url = base_url + "Libros/buscarPorTitulo";
    const http = new XMLHttpRequest();
    http.open("POST", url, true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("titulo=" + encodeURIComponent(titulo));
    http.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            try {
                const res = JSON.parse(this.responseText);
                if (res.success) {
                    mostrarResultadoBusqueda(res.data);
                } else {
                    document.getElementById("sin_resultados").style.display = "block";
                }
            } catch (e) {
                document.getElementById("sin_resultados").style.display = "block";
            }
        }
    }
}

function mostrarResultadoBusqueda(libro) {
    document.getElementById("titulo_encontrado").value = libro.titulo || '';
    document.getElementById("autor_encontrado").value = libro.autor || '';
    document.getElementById("editorial_encontrada").value = libro.editorial || '';
    document.getElementById("anio_encontrado").value = libro.anio || '';
    document.getElementById("descripcion_encontrada").value = libro.descripcion || '';
    
    if (libro.portada) {
        document.getElementById("portada_libro").src = libro.portada;
        document.getElementById("portada_libro").style.display = "block";
    } else {
        document.getElementById("portada_libro").style.display = "none";
    }
    
    document.getElementById("resultado_busqueda").style.display = "block";
}

function usarInformacionEncontrada() {
    // Cerrar modal de escáner
    $("#escanearLibro").modal("hide");
    
    // Abrir modal de nuevo libro y llenar con la información encontrada
    frmLibros();
    
    // Llenar los campos con la información encontrada
    document.getElementById("titulo").value = document.getElementById("titulo_encontrado").value;
    document.getElementById("autor_personal").value = document.getElementById("autor_encontrado").value;
    document.getElementById("editorial").value = document.getElementById("editorial_encontrada").value;
    document.getElementById("descripcion").value = document.getElementById("descripcion_encontrada").value;
    
    // Si hay año, convertirlo a formato de fecha
    const anio = document.getElementById("anio_encontrado").value;
    if (anio) {
        document.getElementById("anio_edicion").value = anio + "-01-01";
    }
    
    // Usar el ISBN como código del libro
    const isbn = document.getElementById("isbn_input").value;
    document.getElementById("codigo_libro").value = isbn;
    
    alertas('Información del libro cargada. Complete los campos restantes y guarde.', 'success');
}

function limpiarBusqueda() {
    document.getElementById("isbn_input").value = "";
    document.getElementById("resultado_busqueda").style.display = "none";
    document.getElementById("sin_resultados").style.display = "none";
    document.getElementById("camara_container").style.display = "none";
    document.getElementById("isbn_input").focus();
}

// Funciones para la cámara (opcional - requiere librería de códigos de barras)
let stream = null;

function activarCamara() {
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
            .then(function(mediaStream) {
                stream = mediaStream;
                const video = document.getElementById('video');
                video.srcObject = mediaStream;
                document.getElementById('camara_container').style.display = 'block';
            })
            .catch(function(error) {
                alertas('No se pudo acceder a la cámara: ' + error.message, 'error');
            });
    } else {
        alertas('Tu navegador no soporta acceso a la cámara', 'warning');
    }
}

function cerrarCamara() {
    if (stream) {
        stream.getTracks().forEach(track => track.stop());
        stream = null;
    }
    document.getElementById('camara_container').style.display = 'none';
}

function capturarCodigo() {
    // Esta función requeriría una librería como QuaggaJS o ZXing para decodificar códigos de barras
    // Por ahora, solo captura la imagen
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const context = canvas.getContext('2d');
    
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0);
    
    alertas('Imagen capturada. Para decodificar códigos de barras se requiere una librería adicional.', 'info');
}

// Event listener para detectar cuando se presiona Enter en el campo ISBN o Título

document.addEventListener('DOMContentLoaded', function() {
    const isbnInput = document.getElementById('isbn_input');
    if (isbnInput) {
        isbnInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                buscarPorISBN();
            }
        });
    }
    const tituloInput = document.getElementById('titulo_input');
    if (tituloInput) {
        tituloInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                buscarPorTitulo();
            }
        });
    }
    const modoBusqueda = document.getElementById('modo_busqueda');
    if (modoBusqueda) {
        modoBusqueda.addEventListener('change', alternarModoBusqueda);
    }
});
