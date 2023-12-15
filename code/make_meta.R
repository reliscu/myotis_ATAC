setwd("/Users/rebecca/sudmant/analyses/myotis")

meta <- data.frame(
    Field_Name = c("Myotis-Auriculus", "Myotis-Lucifugus", "Myotis-Velifer",
                 "Myotis-Californicus", "Myotis-Occultus", "Myotis-Volans",
                 "Myotis-Evotis", "Myotis-Thysanodes", "Myotis-Yumanensis"),
    Abbr = c("mMyoAui", "mMyoCai", "mMyoEvo",
           "mMyoLuc", "mMyoOcc", "mMyoThy",
           "mMyoVel", "mMyoVol", "mMyoYum")
    )

write.csv(meta, file = "data/myotis_meta.csv", row.names = FALSE, quote = FALSE)
