(ns fetch-link-fields.core
  (:require [clj-http.client :as client]
            [net.cgrand.enlive-html :as html]
            [clojure.java.io :as io]
            [clojure.string :as s]))

(defn load-ids [file]
  (-> file slurp (s/split #"\n")))

(defn get-773 [id]
  (let [url (str "http://replikointi-kk.lib.helsinki.fi/cvs/" id)
        dom (:body (client/get url))]
    (first (s/split (re-find #"\d+ 773.*" dom) #"</"))))

(defn process-all [inputfile outputfile]
  (doseq [id (load-ids inputfile)]
    (Thread/sleep 3000)
    (let [res (get-773 id)]
      (println res)
      (spit outputfile (str res "\n") :append true))))
