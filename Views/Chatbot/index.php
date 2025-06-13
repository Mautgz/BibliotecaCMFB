<?php
require_once 'Views/header.php';
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">El Bibliotecario del CMFB</h3>
                </div>
                <div class="card-body">
                    <div class="chat-container">
                        <div class="chat-messages" id="chatMessages">
                            <div class="message bot-message">
                                <div class="message-content">
                                    ¡Hola! Soy el asistente virtual de la biblioteca. ¿En qué puedo ayudarte hoy?
                                </div>
                            </div>
                            <button class="scroll-down-btn" id="scrollDownBtn" title="Bajar al final">&#8595;</button>
                        </div>
                        <div class="chat-input">
                            <form id="chatForm" class="d-flex">
                                <input type="text" id="userInput" class="form-control" placeholder="Escribe tu pregunta aquí...">
                                <button type="submit" class="btn btn-primary ms-2">
                                    <i class="fas fa-paper-plane"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.chat-container {
    height: 600px;
    display: flex;
    flex-direction: column;
}

.chat-messages {
    max-height: 300px !important;
    min-height: 100px !important;
    height: 300px !important;
    overflow-y: auto !important;
    position: relative !important;
    background: #f8f9fa !important;
    border: 2px solid #007bff !important;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 20px;
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

.message {
    margin-bottom: 15px;
    display: flex;
    flex-direction: column;
}

.user-message {
    align-items: flex-end;
}

.bot-message {
    align-items: flex-start;
}

.message-content {
    max-width: 70%;
    padding: 10px 15px;
    border-radius: 15px;
    font-size: 14px;
}

.user-message .message-content {
    background: #007bff;
    color: white;
}

.bot-message .message-content {
    background: white;
    border: 1px solid #dee2e6;
}

.book-suggestion {
    background: white;
    border: 1px solid #dee2e6;
    border-radius: 10px;
    padding: 15px;
    margin-top: 10px;
}

.book-suggestion h5 {
    margin: 0 0 10px 0;
    color: #007bff;
}

.book-suggestion p {
    margin: 5px 0;
    font-size: 13px;
}

.chat-input {
    padding: 20px;
    background: white;
    border-top: 1px solid #dee2e6;
}

.chat-input form {
    display: flex;
    gap: 10px;
}

.chat-input input {
    flex-grow: 1;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const chatForm = document.getElementById('chatForm');
    const userInput = document.getElementById('userInput');
    const chatMessages = document.getElementById('chatMessages');
    const scrollDownBtn = document.getElementById('scrollDownBtn');

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
    
    books.forEach(book => {
        console.log('Libro recibido para renderizar:', book);

        const bookDiv = document.createElement('div');
        bookDiv.className = 'book-suggestion';
        
        bookDiv.innerHTML = `
            <h5>${book.titulo}</h5>
            <p><strong>Autor:</strong> ${book.autor_personal || book.autor || 'No especificado'}</p>
            <p><strong>Editorial:</strong> ${book.editorial || 'No especificada'}</p>
            <p><strong>Materia:</strong> ${book.materia || 'No especificada'}</p>
            <p><strong>Código:</strong> ${book.codigo_libro || 'No especificado'}</p>
            <p><strong>Ubicación:</strong> ${book.ubicacion || 'No especificada'}</p>
            <p><strong>Estado:</strong> <span style="color:${book.estado === 'Disponible' ? 'green' : 'red'}">${book.estado || 'No especificado'}</span></p>
        `;
        contentDiv.appendChild(bookDiv);

        // Mostrar el resumen en un cuadro aparte debajo del detalle del libro
        if (book.resumen) {
            const resumenDiv = document.createElement('div');
            resumenDiv.className = 'chat-resumen';
            resumenDiv.style.background = '#fffbe6';
            resumenDiv.style.border = '1px solid #ffe58f';
            resumenDiv.style.borderRadius = '8px';
            resumenDiv.style.margin = '10px 0 20px 0';
            resumenDiv.style.padding = '12px 16px';
            resumenDiv.innerHTML = `<strong>Resumen:</strong><br>${book.resumen.replace(/\\n/g, '<br>')}`;
            contentDiv.appendChild(resumenDiv);
        } else {
            // DEPURACIÓN: Si no hay resumen, muestra un mensaje
            const resumenDiv = document.createElement('div');
            resumenDiv.className = 'chat-resumen';
            resumenDiv.style.background = '#ffeaea';
            resumenDiv.style.border = '1px solid #ffb3b3';
            resumenDiv.style.borderRadius = '8px';
            resumenDiv.style.margin = '10px 0 20px 0';
            resumenDiv.style.padding = '12px 16px';
            resumenDiv.innerHTML = `<strong>Resumen:</strong> <em>No se encontró información adicional sobre este libro.</em>`;
            contentDiv.appendChild(resumenDiv);
        }
    });
    
    suggestionsDiv.appendChild(contentDiv);
    chatMessages.appendChild(suggestionsDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

    chatForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const query = userInput.value.trim();
        if (!query) return;

        // Agregar mensaje del usuario
        addMessage(query, true);
        userInput.value = '';

        try {
            const response = await fetch(base_url + 'Chatbot/obtenerRespuesta', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'query=' + encodeURIComponent(query)
            });

            const data = await response.json();
            
            // Agregar respuesta del bot
            addMessage(data.respuesta);
            
            // Agregar sugerencias de libros
            if (data.libros && data.libros.length > 0) {
                addBookSuggestions(data.libros);
            }
        } catch (error) {
            console.error('Error:', error);
            addMessage('Lo siento, ha ocurrido un error al procesar tu consulta.');
        }
    });

    // Llama a checkChatOverflow al cargar la página y después de cada mensaje
    checkChatOverflow();
});
</script>

<?php
require_once 'Views/footer.php';
?> 