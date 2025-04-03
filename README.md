graph TD
    subgraph UI Layer
        HS[HomeScreen]
        MPS[MyPageScreen]
        CV[CustomTitle]
        DB[DraggableBar]
        PL[PlaceList]
        PDB[PositionedDecoratedBox]
        PT[PositionedText]
        PP[ProfilePhoto]
    end

    subgraph ViewModel Layer
        CVM[CoupleViewModel]
        PVM[PlaceViewModel]
        AVM[AuthViewModel]
    end

    subgraph Repository Layer
        CR[CoupleRepository]
    end

    subgraph DataSource Layer
        FCS[FirestoreCoupleService]
    end

    subgraph Models
        C[Couple Model]
        U[User Model]
        P[Place Model]
    end

    %% UI Layer Connections
    HS --> CVM
    HS --> AVM
    HS --> PVM
    HS --> CV
    HS --> DB
    HS --> PL
    HS --> PDB
    HS --> PT
    HS --> PP
    MPS --> AVM
    MPS --> PP

    %% ViewModel Layer Connections
    CVM --> CR
    CVM --> AVM
    PVM --> AVM

    %% Repository Layer Connections
    CR --> FCS

    %% DataSource Layer Connections
    FCS --> C
    FCS --> U

    %% Model Usage
    CVM --> C
    CVM --> U
    PVM --> P

    classDef ui fill:#f9f,stroke:#333,stroke-width:2px;
    classDef viewmodel fill:#bbf,stroke:#333,stroke-width:2px;
    classDef repository fill:#bfb,stroke:#333,stroke-width:2px;
    classDef datasource fill:#fbb,stroke:#333,stroke-width:2px;
    classDef model fill:#fbf,stroke:#333,stroke-width:2px;

    class HS,MPS,CV,DB,PL,PDB,PT,PP ui;
    class CVM,PVM,AVM viewmodel;
    class CR repository;
    class FCS datasource;
    class C,U,P model;
