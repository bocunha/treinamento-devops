resource "local_file" "Aula" {
  count = 10
  filename = "Aula-${count.index + 1}.txt"
  content = "Olá alunos bem vindo ao terraform ${count.index + 1}.0\n"
  directory_permission = "0644"
  file_permission      = "0644"
}