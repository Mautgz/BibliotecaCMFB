<?php
class PublicChatbot extends Controller
{
    public function index()
    {
        $this->views->getView($this, "public_chatbot");
    }
} 