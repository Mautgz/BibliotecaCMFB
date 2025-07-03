<?php
// Debug: show that the partial is loaded
echo '<!-- Chatbot loaded -->';
// Ensure session is started
if (session_status() !== PHP_SESSION_ACTIVE) session_start();
// TEMPORAL: Mostrar siempre el chatbot para depuración
?>
<div class="chatbot-container">
    <div class="chatbot-icon" id="chatbotIcon">
        <i class="fa fa-comments"></i>
    </div>
    <div class="chatbot-window" id="chatbotWindow">
        <div class="chatbot-header">
            <h5>Asistente Virtual</h5>
            <button class="btn btn-link p-0 text-white" id="closeChatbot">
                <i class="fa fa-times"></i>
            </button>
        </div>
        <div class="chatbot-body">
            <div class="chat-messages" id="chatMessages">
                <div class="message bot-message">
                    <div class="message-content">
                        Mi nombre es Mister Biblio, soy el asistente virtual de la biblioteca. Estoy aquí para ayudarte a encontrar libros, informarte sobre nuestros servicios y horarios, y responder cualquier pregunta que tengas sobre la biblioteca. ¿En qué puedo ayudarte hoy?
                    </div>
                </div>
                <button class="scroll-down-btn" id="scrollDownBtn" title="Bajar al final">&#8595;</button>
            </div>
            <div id="chatbotLoader" style="display:none; text-align:center; margin:10px 0;">
                <span class="loader"></span>
                <span style="font-size:13px; color:#888;">Pensando...</span>
            </div>
            <div class="chat-input">
                <form id="chatForm" class="d-flex">
                    <input type="text" id="userInput" class="form-control" placeholder="Escribe tu pregunta aquí...">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-paper-plane"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<style>
.chatbot-container {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 1000;
    transition: all 0.3s ease;
}

.chatbot-icon {
    width: 60px;
    height: 60px;
    background: #007bff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    transition: all 0.3s ease;
}

.chatbot-icon:hover {
    transform: scale(1.1);
    background: #0056b3;
}

.chatbot-icon i {
    color: white;
    font-size: 24px;
}

.chatbot-window {
    position: fixed;
    bottom: 90px;
    right: 20px;
    width: 350px;
    height: 500px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.15);
    display: none;
    flex-direction: column;
    overflow: hidden;
}

.chatbot-window.active {
    display: flex;
}

.chatbot-header {
    background: #007bff;
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.chatbot-header h5 {
    margin: 0;
    font-size: 16px;
}

.chatbot-body {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #f8f9fa;
}

.chat-messages {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    max-height: 300px !important;
    min-height: 100px !important;
    height: 300px !important;
    position: relative !important;
    background: #f8f9fa !important;
    border: 2px solid #007bff !important;
    border-radius: 10px;
    margin-bottom: 20px;
}

.message {
    margin-bottom: 10px;
    max-width: 80%;
}

.message-content {
    padding: 10px 15px;
    border-radius: 15px;
    background: white;
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.user-message {
    margin-left: auto;
}

.user-message .message-content {
    background: #007bff;
    color: white;
}

.bot-message {
    margin-right: auto;
}

.chat-input {
    padding: 15px;
    background: white;
    border-top: 1px solid #eee;
}

.chat-input form {
    display: flex;
    gap: 10px;
}

.chat-input input {
    flex: 1;
    border: 1px solid #ddd;
    border-radius: 20px;
    padding: 8px 15px;
}

.chat-input button {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}

.loader {
    width: 20px;
    height: 20px;
    border: 2px solid #f3f3f3;
    border-top: 2px solid #007bff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    display: inline-block;
    margin-right: 5px;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.book-suggestion {
    background: white;
    padding: 10px;
    border-radius: 5px;
    margin-top: 5px;
    border: 1px solid #eee;
}

.book-suggestion h6 {
    margin: 0 0 5px 0;
    color: #007bff;
}

.book-suggestion p {
    margin: 0;
    font-size: 12px;
    color: #666;
}

.student-suggestion {
    background: white;
    padding: 10px;
    border-radius: 5px;
    margin-top: 5px;
    border: 1px solid #eee;
}

.student-suggestion h6 {
    margin: 0 0 5px 0;
    color: #007bff;
}

.student-suggestion p {
    margin: 0;
    font-size: 12px;
    color: #666;
}

.loan-suggestion {
    background: white;
    padding: 10px;
    border-radius: 5px;
    margin-top: 5px;
    border: 1px solid #eee;
}

.loan-suggestion h6 {
    margin: 0 0 5px 0;
    color: #007bff;
}

.loan-suggestion p {
    margin: 0;
    font-size: 12px;
    color: #666;
}

.loan-suggestion span {
    font-weight: 500;
}

.scroll-down-btn {
    display: none;
    position: absolute;
    right: 16px;
    bottom: 16px;
    z-index: 10;
    background: #007bff;
    color: #fff;
    border: none;
    border-radius: 50%;
    width: 36px;
    height: 36px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    cursor: pointer;
    align-items: center;
    justify-content: center;
    font-size: 20px;
}

.chat-messages.has-overflow .scroll-down-btn {
    display: flex;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const chatbotIcon = document.getElementById('chatbotIcon');
    const chatbotWindow = document.getElementById('chatbotWindow');
    const closeChatbot = document.getElementById('closeChatbot');
    const chatForm = document.getElementById('chatForm');
    const userInput = document.getElementById('userInput');
    const chatMessages = document.getElementById('chatMessages');
    const chatbotLoader = document.getElementById('chatbotLoader');
    const scrollDownBtn = document.getElementById('scrollDownBtn');

    chatbotIcon.addEventListener('click', function() {
        chatbotWindow.classList.add('active');
    });

    closeChatbot.addEventListener('click', function() {
        chatbotWindow.classList.remove('active');
    });

    function checkChatOverflow() {
        setTimeout(() => {
            if (chatMessages.scrollHeight > chatMessages.clientHeight + 5) {
                chatMessages.classList.add('has-overflow');
                scrollDownBtn.style.display = 'flex';
            } else {
                chatMessages.classList.remove('has-overflow');
                scrollDownBtn.style.display = 'none';
            }
        }, 50);
    }

    scrollDownBtn.addEventListener('click', function() {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    });

    function addMessage(content, isUser = false) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${isUser ? 'user-message' : 'bot-message'}`;
        const messageContent = document.createElement('div');
        messageContent.className = 'message-content';
        messageContent.textContent = content;
        messageDiv.appendChild(messageContent);
        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
        checkChatOverflow();
    }

    function addBookSuggestions(books) {
        if (!books || books.length === 0) return;
        const suggestionsDiv = document.createElement('div');
        suggestionsDiv.className = 'message bot-message';
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        // Mostrar todos los libros devueltos por el backend
        books.forEach(book => {
            const bookDiv = document.createElement('div');
            bookDiv.className = 'book-suggestion';
            bookDiv.innerHTML = `
                <h6>${book.titulo}</h6>
                <p><strong>Autor:</strong> ${book.autor_personal || book.autor || 'No especificado'}</p>
                <p><strong>Editorial:</strong> ${book.editorial || 'No especificada'}</p>
                <p><strong>Materia:</strong> ${book.materia || 'No especificada'}</p>
                <p><strong>Código:</strong> ${book.codigo_libro || 'No especificado'}</p>
                <p><strong>Ubicación:</strong> ${book.ubicacion || 'No especificada'}</p>
                <p><strong>Estado:</strong> <span style="color:${book.estado === 'Disponible' ? 'green' : 'red'}">${book.estado || 'No especificado'}</span></p>
            `;
            contentDiv.appendChild(bookDiv);
        });
        suggestionsDiv.appendChild(contentDiv);
        chatMessages.appendChild(suggestionsDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function addStudentSuggestions(students) {
        if (!students || students.length === 0) return;
        const suggestionsDiv = document.createElement('div');
        suggestionsDiv.className = 'message bot-message';
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        // Limitar a 2 estudiantes
        const limitedStudents = students.slice(0, 2);
        
        limitedStudents.forEach(student => {
            const studentDiv = document.createElement('div');
            studentDiv.className = 'student-suggestion';
            studentDiv.innerHTML = `
                <h6>${student.nombre} ${student.apellido}</h6>
                <p><strong>Código:</strong> ${student.codigo || 'No especificado'}</p>
                <p><strong>Email:</strong> ${student.email || 'No especificado'}</p>
                <p><strong>Teléfono:</strong> ${student.telefono || 'No especificado'}</p>
                <p><strong>Dirección:</strong> ${student.direccion || 'No especificada'}</p>
            `;
            contentDiv.appendChild(studentDiv);
        });
        suggestionsDiv.appendChild(contentDiv);
        chatMessages.appendChild(suggestionsDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function addLoanSuggestions(loans) {
        if (!loans || loans.length === 0) return;
        const suggestionsDiv = document.createElement('div');
        suggestionsDiv.className = 'message bot-message';
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        // Limitar a 2 préstamos
        const limitedLoans = loans.slice(0, 2);
        
        limitedLoans.forEach(loan => {
            const loanDiv = document.createElement('div');
            loanDiv.className = 'loan-suggestion';
            loanDiv.innerHTML = `
                <h6>Préstamo #${loan.id}</h6>
                <p><strong>Estudiante:</strong> ${loan.nombre_estudiante || 'No especificado'}</p>
                <p><strong>Libro:</strong> ${loan.titulo_libro || 'No especificado'}</p>
                <p><strong>Fecha de préstamo:</strong> ${loan.fecha_prestamo || 'No especificada'}</p>
                <p><strong>Fecha de devolución:</strong> ${loan.fecha_devolucion || 'No especificada'}</p>
                <p><strong>Estado:</strong> <span style="color: ${loan.estado === 'Activo' ? '#28a745' : '#dc3545'}">${loan.estado || 'No especificado'}</span></p>
                <p><strong>Observaciones:</strong> ${loan.observaciones || 'No especificadas'}</p>
            `;
            contentDiv.appendChild(loanDiv);
        });
        suggestionsDiv.appendChild(contentDiv);
        chatMessages.appendChild(suggestionsDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // Lista de saludos y presentaciones comunes
    const saludos = [
        'hola', 'buenos días', 'buenas tardes', 'buenas noches', 'saludos',
        'mucho gusto', 'encantado', 'encantada', 'un placer', 'gusto en conocerte',
        'como estas', 'cómo estás', 'que tal', 'qué tal', 'bienvenido', 'bienvenida'
    ];

    chatForm.addEventListener('submit', async function (e) {
        e.preventDefault();
        const consulta = userInput.value.trim();
        if (!consulta) return;

        // Agregar mensaje del usuario
        addMessage(consulta, true);
        userInput.value = '';
        chatbotLoader.style.display = 'block';

        // Verificar si es un saludo
        const esSaludo = saludos.some(saludo => 
            consulta.toLowerCase().includes(saludo.toLowerCase())
        );

        if (esSaludo) {
            addMessage("¡Hola! Soy Mister Biblio, ¿en qué puedo ayudarte hoy? Puedo ayudarte a buscar libros, informarte sobre nuestros servicios o responder tus preguntas sobre la biblioteca.");
            chatbotLoader.style.display = 'none';
            return;
        }

        // Verificar si la pregunta está relacionada con búsqueda de libros
        const preguntasLibros = [
            'buscar', 'encontrar', 'libro', 'libros', 'autor', 'título', 'editorial',
            'materia', 'código', 'ubicación', 'estado', 'disponible', 'préstamo',
            'catalogo', 'catálogo', 'biblioteca', 'donde', 'dónde', 'cual', 'cuál'
        ];

        // const esBusquedaLibros = preguntasLibros.some(palabra => 
        //     consulta.toLowerCase().includes(palabra.toLowerCase())
        // );

        // if (!esBusquedaLibros) {
        //     // Si no es búsqueda de libros, responder directamente
        //     addMessage("Soy Mister Biblio, el asistente virtual de la biblioteca. Puedo ayudarte a buscar libros, información sobre préstamos y más. ¿Qué necesitas saber?");
        //     chatbotLoader.style.display = 'none';
        //     return;
        // }

        try {
            const respuesta = await fetch(base_url + 'Chatbot/obtenerRespuesta', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'query=' + encodeURIComponent(consulta)
            });
            const output = await respuesta.text();
            let datos;
            try {
                datos = JSON.parse(output);
            } catch (e) {
                console.error("Respuesta no es JSON válido:", output);
                addMessage("Lo siento, ha ocurrido un error al procesar la respuesta del servidor.");
                chatbotLoader.style.display = 'none';
                return;
            }
            addMessage(datos.respuesta);
            if (datos.libros && datos.libros.length > 0) {
                addBookSuggestions(datos.libros);
            }
            if (datos.estudiantes && datos.estudiantes.length > 0) {
                addStudentSuggestions(datos.estudiantes);
            }
            if (datos.prestamos && datos.prestamos.length > 0) {
                addLoanSuggestions(datos.prestamos);
            }
        } catch (error) {
            console.error("Error al procesar la respuesta del script Python:", error);
            addMessage("Lo siento, ha ocurrido un error al procesar tu consulta.");
        } finally {
            chatbotLoader.style.display = 'none';
        }
    });

    // Llama a checkChatOverflow al cargar la página
    checkChatOverflow();
});
</script>