-- A premake file just bundles all the properties of the entire project so it can be compiled on Windows, Apple, Linux...
-- Different compilers can just use this with premake to get the necessary information about the project.

-- workspace is the same as a solution in Visual Studio
workspace "Hazel"
	architecture "x64"

	configurations{
		"Debug",		-- No optimization, logging on		Debugging purpose
		"Release",		-- Optimization, logging on			Testing purpose
		"Dist"			-- Optimization, loggin off			Final build
	}

	outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"		-- So something like: Debug-Windows-x64

	startproject "Sandbox"
	-- Include directories relative to root folder (solution directory)
	IncludeDir = {}
	IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
	IncludeDir["Glad"] = "Hazel/vendor/Glad/include"
	IncludeDir["ImGui"] = "Hazel/vendor/imgui"

	-- Like c++ preprocessor include, just takes premake lua file from this directory and pastes it here.
	include "Hazel/vendor/GLFW"
	include "Hazel/vendor/Glad"
	include "Hazel/vendor/imgui"


project "Hazel"

	location "Hazel"		-- Define a relative path as to which all the other locations are relative to
	kind "SharedLib"		-- General term for DLL (cuz DLL is just a Windows thing)
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")		-- Binary folder
	objdir ("bin/" .. outputdir .. "/%{prj.name}")			-- Intermidiate binary folder

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	-- What files to add
	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	-- What libs to include
	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}"
	}

	links
	{
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib"
	}

	-- Everything under filter only for that filter untill other filter, indentation doesn't matter
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"			-- If you don't specify any Windows 10 SDK at all, it will default to 8.1 which isn't installed on every pc
		
		defines
		{
			"HZ_PLATFORM_WINDOWS",
			"HZ_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
		}

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		buildoptions "/MDd"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")		-- Binary folder
	objdir ("bin/" .. outputdir .. "/%{prj.name}")			-- Intermidiate binary folder

	-- What files to add
	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	-- What libs to include
	includedirs
	{
		"Hazel/vendor/spdlog/include",
		"Hazel/src"
	}

	links
	{
		"Hazel"
	}

	-- Everything under filter only for that filter untill other filter, indentation doesn't matter
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"			-- If you don't specify any Windows 10 SDK at all, it will default to 8.1 which isn't installed on every pc
		
		defines
		{
			"HZ_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		buildoptions "/MDd"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "On"