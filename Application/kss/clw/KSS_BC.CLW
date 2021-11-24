  MEMBER('kss.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('kss_BC0.CLW')
kss_BC0:DctInit             PROCEDURE()
kss_BC0:DctKill             PROCEDURE()
kss_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  kss_BC0:DctInit
  kss_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  kss_BC0:DctKill

