filepath +:./modules/Sakura

coord
{
  name          c_Sakura
  parent        Earth

  # Keep this at 1 meter
  unit          1.000000
  entrydist     100000
  # Change this file to place on desire longitude/latitude and altitude
  positionfile  SakuraPos.conf

  rotation
  {
    surfacepositioner
    {
      static hpr 180.0 0.0 0
    }
  }
}

object Sakura sgOrbitalObject
{
  coord c_Sakura
  geometry SG_USES Sakura.conf

  # 10 meter
  cameraRadius 5
  # 20 meter
  targetRadius 10

  lsize 1000000

  guiName /climate change/cherry blossoms
}
