import { ChangeEventHandler, ReactNode } from "react"

interface DaerahDropdownProps {
  id: string
  label: string
  children: ReactNode
  value?: string
  onChange?: ChangeEventHandler<HTMLSelectElement>
}
function DaerahDropdown({ id, label, children, value, onChange }: DaerahDropdownProps) {
  return (
    <div className="flex flex-col">
      <label htmlFor={id} className="text-sm">{label}</label>
      <select
        name={id} id={id}
        className="border-primary/10 border"
        onChange={onChange} value={value}
      >
        {children}
      </select>
    </div>
  )
}

export default DaerahDropdown