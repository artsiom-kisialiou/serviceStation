USE [master]
GO
/****** Object:  Database [ServiceDB]    Script Date: 24.09.2019 12:36:52 ******/
CREATE DATABASE [ServiceDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ServiceDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ServiceDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ServiceDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ServiceDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [ServiceDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ServiceDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ServiceDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ServiceDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ServiceDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ServiceDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ServiceDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ServiceDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ServiceDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ServiceDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ServiceDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ServiceDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ServiceDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ServiceDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ServiceDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ServiceDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ServiceDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ServiceDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ServiceDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ServiceDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ServiceDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ServiceDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ServiceDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ServiceDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ServiceDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ServiceDB] SET  MULTI_USER 
GO
ALTER DATABASE [ServiceDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ServiceDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ServiceDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ServiceDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ServiceDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ServiceDB] SET QUERY_STORE = OFF
GO
USE [ServiceDB]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 24.09.2019 12:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[DateBirth] [date] NULL,
	[Address] [varchar](50) NULL,
	[Phone] [int] NULL,
	[Email] [varchar](50) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 24.09.2019 12:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[itemID] [int] IDENTITY(1,1) NOT NULL,
	[Make] [varchar](50) NULL,
	[Model] [nchar](10) NULL,
	[Year] [int] NULL,
	[VIN] [varchar](50) NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[itemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 24.09.2019 12:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](50) NULL,
	[CustomerID] [int] NULL,
	[Date] [date] NULL,
	[OrderAmount] [int] NULL,
	[OrderStatus] [varchar](50) NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 24.09.2019 12:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[itemID] [int] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[OrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Item] FOREIGN KEY([itemID])
REFERENCES [dbo].[Item] ([itemID])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Item]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Order]
GO
USE [master]
GO
ALTER DATABASE [ServiceDB] SET  READ_WRITE 
GO
