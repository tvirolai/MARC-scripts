(ns download-dump.core
  (:require [clojure.java.io :as io]
            [clojure.tools.cli :refer [parse-opts]])
  (:gen-class))

; The program downloads Melinda dump files from the replication server,
; streaming them into a single, humongous Aleph sequential file.

(defn URLs
  [urlrange]
  (map 
    #(str "http://replikointi-kk.lib.helsinki.fi/index/alina" (if (< % 10) 0) % ".seq") 
       (range urlrange)))

(defn delete-existing
  [file]
  (if (.exists (io/as-file file))
    (do
      (println (str "File " file " exists, deleting it."))
      (io/delete-file file))
    (println (str "Created file " file "."))))

(defn download [uri file]
  (try
    (with-open [in (io/input-stream uri) 
                out (io/output-stream file :append true)]
      (println (str "Downloading file " uri "."))
      (io/copy in out))
  (catch java.io.FileNotFoundException e
    (println (str "Not found: " uri)))))

(def cli-options
  [["-f" "--file FILE" "Input file"
    :validate [identity "Usage: java -jar download-dump.jar -f outputfile"]]])

(defn -main [& args]
  (let [parsed-args (parse-opts args cli-options)
        outputfile (:file (:options parsed-args))]
    (do
      (delete-existing outputfile)
      (doseq [x (URLs 15)]
       (download x outputfile)))))
