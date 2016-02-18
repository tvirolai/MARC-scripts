(ns readDump
  (:require [clojure.java.io :as io]))

; Ohjelma lataa replikointipalvelimelta Melindan datan yhteen
; Aleph Sequential -tiedostoon, jonka nimi on määritelty outputFile-arvossa.

(def outputFile
  "../dumppi.seq")

(defn URLs
  [urlRange]
  (apply list
    (map 
    #(str "http://replikointi-kk.lib.helsinki.fi/index/alina" (if (< % 10) 0) % ".seq") 
    (range urlRange))))

(defn delete-existing
  [file]
  (if (.exists (io/as-file file))
    (do
      (println (str "File " file " exists, deleting it."))
      (io/delete-file file))
    (println (str "Created file " file "."))))

(defn file-exists?
  [file]
  (.exists (io/as-file file)))

(defn download [uri file]
  (with-open [in (io/input-stream uri) 
    out (io/output-stream file :append true)]
    (println (str "Downloading file " uri "."))
    (io/copy in out)))

(delete-existing outputFile)

(doseq [x (URLs 15)]
 (download x outputFile))