const copyButton = document.getElementById("copyProject");
const toast = document.getElementById("toast");

if (copyButton && toast) {
  copyButton.addEventListener("click", async () => {
    const projectName = "Cloud-Based Static Website Hosting using Google Cloud Storage";
    try {
      await navigator.clipboard.writeText(projectName);
      toast.textContent = "Project name copied!";
    } catch {
      toast.textContent = projectName;
    }
    toast.classList.add("show");
    window.setTimeout(() => toast.classList.remove("show"), 2200);
  });
}
