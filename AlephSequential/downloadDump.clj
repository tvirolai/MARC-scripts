(ns downloadDump
  (:require [clojure.java.io :as io]))

; The program downloads Melinda dump files from the replication server,
; streaming them into a single, humongous Aleph sequential file defined as the var "outputFile".

(def outputFile
  "/home/tuomo/Melinda-dumppi/dumppi.seq")

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
  (try
    (with-open [in (io/input-stream uri) 
      out (io/output-stream file :append true)]
      (println (str "Downloading file " uri "."))
      (io/copy in out))
  (catch java.io.FileNotFoundException e
    (prn (str "Not found: " uri)))))

(delete-existing outputFile)

(doseq [x (URLs 15)]
 (download x outputFile))