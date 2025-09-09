# Git: FF, Cherry-Pick y Rebase

Fast-Forward (FF) mueve el puntero de la rama `master` hacia adelante del commit de la rama que vamos a integrar.  
**Ejemplo:**  
master: A  
feature/msg: A → B  
**Comando:** `git merge --ff-only feature/msg`  
**Resultado:**  
master: B  
feature/msg: A → B

Cherry-Pick copia un commit específico de una rama y lo aplica a otra sin traer los demás commits.  
**Ejemplo:**  
master: A  
feature: A → B → C  
**Comando:** `git cherry-pick B`  
**Resultado:**  
master: A → B' (commit copiado)  
feature: A → B → C

Rebase corto cambia la base de los commits de una rama para que parezca que se hizo sobre la última versión de otra rama.  
**Ejemplo:**  
master: A → B'  
feature: A → B → C  
**Comando:** `git rebase master`  
**Resultado:**  
master: B'  
feature: A → B → C  

Es como si siempre hubiéramos trabajado con B'.

