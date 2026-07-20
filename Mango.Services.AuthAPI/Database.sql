
/****** Object:  Table [xMango_Auth].[dbo].[AspNetRoleClaims]    Script Date: 2026-07-11 12:02:53 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetRoleClaims] (
    [Id] [INT] IDENTITY(1, 1) NOT NULL,
    [RoleId] [NVARCHAR](450) NOT NULL,
    [ClaimType] [NVARCHAR](MAX) NULL,
    [ClaimValue] [NVARCHAR](MAX) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [xMango_Auth].[dbo].[AspNetRoles]    Script Date: 2026-07-11 12:02:54 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetRoles] (
    [Id] [NVARCHAR](450) NOT NULL,
    [Name] [NVARCHAR](256) NULL,
    [NormalizedName] [NVARCHAR](256) NULL,
    [ConcurrencyStamp] [NVARCHAR](MAX) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [xMango_Auth].[dbo].[AspNetUserClaims]    Script Date: 2026-07-11 12:02:54 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetUserClaims] (
    [Id] [INT] IDENTITY(1, 1) NOT NULL,
    [UserId] [NVARCHAR](450) NOT NULL,
    [ClaimType] [NVARCHAR](MAX) NULL,
    [ClaimValue] [NVARCHAR](MAX) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [xMango_Auth].[dbo].[AspNetUserLogins]    Script Date: 2026-07-11 12:02:54 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetUserLogins] (
    [LoginProvider] [NVARCHAR](450) NOT NULL,
    [ProviderKey] [NVARCHAR](450) NOT NULL,
    [ProviderDisplayName] [NVARCHAR](MAX) NULL,
    [UserId] [NVARCHAR](450) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [xMango_Auth].[dbo].[AspNetUserRoles]    Script Date: 2026-07-11 12:02:54 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetUserRoles] (
    [UserId] [NVARCHAR](450) NOT NULL,
    [RoleId] [NVARCHAR](450) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [xMango_Auth].[dbo].[AspNetUsers]    Script Date: 2026-07-11 12:02:54 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetUsers] (
    [Id] [NVARCHAR](450) NOT NULL,
    [UserName] [NVARCHAR](256) NULL,
    [NormalizedUserName] [NVARCHAR](256) NULL,
    [Email] [NVARCHAR](256) NULL,
    [NormalizedEmail] [NVARCHAR](256) NULL,
    [EmailConfirmed] [BIT] NOT NULL,
    [PasswordHash] [NVARCHAR](MAX) NULL,
    [SecurityStamp] [NVARCHAR](MAX) NULL,
    [ConcurrencyStamp] [NVARCHAR](MAX) NULL,
    [PhoneNumber] [NVARCHAR](MAX) NULL,
    [PhoneNumberConfirmed] [BIT] NOT NULL,
    [TwoFactorEnabled] [BIT] NOT NULL,
    [LockoutEnd] [DATETIMEOFFSET](7) NULL,
    [LockoutEnabled] [BIT] NOT NULL,
    [AccessFailedCount] [INT] NOT NULL,
    [Name] [NVARCHAR](MAX) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [xMango_Auth].[dbo].[AspNetUserTokens]    Script Date: 2026-07-11 12:02:54 ******/
CREATE TABLE [xMango_Auth].[dbo].[AspNetUserTokens] (
    [UserId] [NVARCHAR](450) NOT NULL,
    [LoginProvider] [NVARCHAR](450) NOT NULL,
    [Name] [NVARCHAR](450) NOT NULL,
    [Value] [NVARCHAR](MAX) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 2026-07-11 12:02:54 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId]
    ON [xMango_Auth].[dbo].[AspNetRoleClaims] (
        [RoleId] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

/****** Object:  Index [RoleNameIndex]    Script Date: 2026-07-11 12:02:54 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [xMango_Auth].[dbo].[AspNetRoles] (
        [NormalizedName] ASC
    )
    WHERE (
        [NormalizedName] IS NOT NULL
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        IGNORE_DUP_KEY = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 2026-07-11 12:02:54 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId]
    ON [xMango_Auth].[dbo].[AspNetUserClaims] (
        [UserId] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 2026-07-11 12:02:54 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId]
    ON [xMango_Auth].[dbo].[AspNetUserLogins] (
        [UserId] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 2026-07-11 12:02:54 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId]
    ON [xMango_Auth].[dbo].[AspNetUserRoles] (
        [RoleId] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

/****** Object:  Index [EmailIndex]    Script Date: 2026-07-11 12:02:54 ******/
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [xMango_Auth].[dbo].[AspNetUsers] (
        [NormalizedEmail] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

/****** Object:  Index [UserNameIndex]    Script Date: 2026-07-11 12:02:54 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [xMango_Auth].[dbo].[AspNetUsers] (
        [NormalizedUserName] ASC
    )
    WHERE ([NormalizedUserName] IS NOT NULL)
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        IGNORE_DUP_KEY = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUsers]
    ADD DEFAULT (N'') FOR [Name]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetRoleClaims]
    WITH CHECK
    ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
    FOREIGN KEY ([RoleId])
    REFERENCES [xMango_Auth].[dbo].[AspNetRoles]([Id])
    ON DELETE CASCADE
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetRoleClaims]
    CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserClaims]
    WITH CHECK
    ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [xMango_Auth].[dbo].[AspNetUsers]([Id])
    ON DELETE CASCADE
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserClaims]
    CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserLogins]
    WITH CHECK
    ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [xMango_Auth].[dbo].[AspNetUsers]([Id])
    ON DELETE CASCADE
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserLogins]
    CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserRoles]
    WITH CHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
    FOREIGN KEY ([RoleId])
    REFERENCES [xMango_Auth].[dbo].[AspNetRoles]([Id])
    ON DELETE CASCADE
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserRoles]
    CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserRoles]
    WITH CHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [xMango_Auth].[dbo].[AspNetUsers]([Id])
    ON DELETE CASCADE
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserRoles]
    CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserTokens]
    WITH CHECK
    ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [xMango_Auth].[dbo].[AspNetUsers]([Id])
    ON DELETE CASCADE
GO

ALTER TABLE [xMango_Auth].[dbo].[AspNetUserTokens]
    CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO



---------------------------------------------------
-- CONTOH 01 - TABLE UNTUK KEPERLUAN AUDIT TRAIL --
---------------------------------------------------

CREATE TABLE [xMango_Auth].[dbo].[h_AspNetRoleClaims] (
    [Id] [INT] NOT NULL,
    [RoleId] [NVARCHAR](450) NOT NULL,
    [ClaimType] [NVARCHAR](MAX) NULL,
    [ClaimValue] [NVARCHAR](MAX) NULL,
    ---------------------------------------------------
    [UpdatedBy] [VARCHAR](50) NULL,
    [UpdatedTime] [DATETIME] NOT NULL -- DEFAULT GETDATE()
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [xMango_Auth].[dbo].[h_AspNetRoleClaims]
    ADD CONSTRAINT [DF_h_AspNetRoleClaims]
    DEFAULT (GETDATE())
    FOR [UpdatedTime]
GO

/*
CREATE NONCLUSTERED INDEX [IX_h_AspNetRoleClaims] -- IsUnique = No
    ON [xMango_Auth].[dbo].[h_AspNetRoleClaims] (
        [Id] ASC,
        [UpdatedTime] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO
*/

CREATE UNIQUE NONCLUSTERED INDEX [IX_h_AspNetRoleClaims] -- IsUnique = Yes
    ON [xMango_Auth].[dbo].[h_AspNetRoleClaims] (
        [Id] ASC,
        [UpdatedTime] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        IGNORE_DUP_KEY = OFF, -- IsUnique = Yes
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

USE [xMango_Auth]
GO

CREATE TRIGGER [TG_h_AspNetRoleClaims]
    ON [xMango_Auth].[dbo].[h_AspNetRoleClaims]
    AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [xMango_Auth].[dbo].[h_AspNetRoleClaims]
    SELECT
    [Id],
    [RoleId],
    [ClaimType],
    [ClaimValue],
    ---------------------------------------------------
    NULL,
    GETDATE()
    FROM [deleted];
END
GO

---------------------------------------------------
-- CONTOH 02 - TABLE UNTUK KEPERLUAN AUDIT TRAIL --
---------------------------------------------------

CREATE TABLE [xMango_Auth].[dbo].[h_AspNetRoleClaims] (
    [Id] [INT] NOT NULL,
    [RoleId] [NVARCHAR](450) NOT NULL,
    [ClaimType] [NVARCHAR](MAX) NULL,
    [ClaimValue] [NVARCHAR](MAX) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_h_AspNetRoleClaims] -- IsUnique = No
    ON [xMango_Auth].[dbo].[h_AspNetRoleClaims] (
        [Id] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        SORT_IN_TEMPDB = OFF,
        DROP_EXISTING = OFF,
        ONLINE = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
GO

USE [xMango_Auth]
GO

CREATE TRIGGER [TG_h_AspNetRoleClaims]
    ON [xMango_Auth].[dbo].[h_AspNetRoleClaims]
    AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [xMango_Auth].[dbo].[h_AspNetRoleClaims]
    SELECT * FROM [deleted];
END
GO
