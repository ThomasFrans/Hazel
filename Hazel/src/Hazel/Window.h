#pragma once

#include "hzpch.h"

#include "Hazel\Core.h"
#include "Hazel\Events\Event.h"

namespace Hazel {

	struct WindowProps
	{
		std::string Title;
		unsigned int Width;
		unsigned int Height;

		// Because a struct is basicly a class with default access modifiers set to public,
		// you can use it's constructor to set (default) values
		// 1280 by 720 is a 16:9 aspect ratio.
		WindowProps(const std::string& title = "Hazel Engine",
			unsigned int width = 1280,
			unsigned int height = 720)
			: Title(title), Width(width), Height(height) {}

	};

	// Interface abstacting a desktop system window, exported by the Hazel API
	// The interface helps switching to a different rendering engine in the future (DirectX, Vulkan, Metal...)
	// which is needed to optimize for different platforms (Windows, Linux, Apple)
	class HAZEL_API Window
	{
	public:
		using EventCallbackFn = std::function<void(Event&)>;

		virtual ~Window() {}

		virtual void OnUpdate() = 0;

		virtual unsigned int GetWidth() const = 0;
		virtual unsigned int GetHeight() const = 0;

		// Window attributes
		virtual void SetEventCallback(const EventCallbackFn& callback) = 0;
		virtual void SetVSync(bool enabled) = 0;
		virtual bool IsVSync() const = 0;

		static Window* Create(const WindowProps& props = WindowProps());

	};

}
