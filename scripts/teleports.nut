teleports <- 
[
    [Vector(123.065, -829.528, 10.62),Vector(117.44, -832.17, 18.39)], // To balcony 
    [Vector(107.153, -847.431, 18.39),Vector(116.62,-824.696, 10.46)], // From balcony
    [Vector(-558.393, 782.065, 22.87),Vector(-559.1, 787.891, 97.51)], // To office upper floor
    [Vector(-551.795, 787.743, 97.51),Vector(-569.1, 780.191, 22.87)], // From office upper floor
    [Vector(-827.627, 1038.38, 15.74),Vector(-826.4, 1051.19, 92.62)], // To 1412 roof
    [Vector(-803.18,  1060.93, 92.62),Vector(-831.1, 1031.3, 15.748)], // From 1412 roof
    [Vector(-830.63,  1312.42, 11.54),Vector(-819.3, 1354.5, 66.457)], // To downtown building
    [Vector(-812.10,  1354.33, 66.46),Vector(-829.9, 1305.26, 11.56)], // From downtown building
    [Vector(-1112.9,  1331.18, 20.11),Vector(-1393.8, 1154.5, 267.4)], // To race stadium
    [Vector(-1090, 1311.05, 9.505),Vector(-1519.58, 999.112, 263.63)], // To derby stadium
    [Vector(-1089.4, 1351.0, 9.50),Vector(-1413.02, 1498.3, 302.825)], // To stunt stadium
    [Vector(-1414.81, 1154.46, 267),Vector(-1104.27, 1331.15, 20.07)], // From race stadium
    [Vector(-1461.03, 941.947, 262),Vector(-1083.04, 1310.29, 9.500)], // From derby stadium
    [Vector(-1413.26, 1507.3, 303.00),Vector(-1073.85,1350.81,12.57)], // From stunt stadium
    [Vector(-410.421, 1120.43, 11.14),Vector(-447.11, 1118.97,56.90)], // To VCN building
    [Vector(-450.401, 1128.06, 56.69),Vector(-413.73, 1115.4, 11.07)], // From VCN building
    [Vector(475.728, 30.20, 12.07),Vector(452.075, 30.2815, 34.8712)], // To gonzales roof
    [Vector(459.195, 30.14, 30.97),Vector(480.798, 29.3114, 11.0712)]  // From gonzales roof
]

function loadCheckpoints()
{
    for(local i = 0; i < teleports.len(); ++i)
    {
        CreateCheckpoint(null, 1, true, teleports[i][0], RGBA(255, 125, 255, 0), 1.8);
    }
}
