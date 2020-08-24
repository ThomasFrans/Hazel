#include <Hazel.h>

// Sandbox is the CLIENT subclass of Application class in the Hazel namespace
class Sandbox : public Hazel::Application
{
public:

	Sandbox()
	{

	}

	~Sandbox()
	{

	}

};

Hazel::Application* Hazel::CreateApplication()
{
	return new Sandbox();
}