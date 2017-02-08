#include "qml_node_base.hpp"
#include <ossia-qt/device/qml_device.hpp>
#include <ossia-qt/device/qml_node.hpp>
#include <ossia/network/base/node.hpp>

namespace ossia
{
namespace qt
{

qml_node_base::qml_node_base(QObject* parent):
  QObject{parent},
  m_device{&qml_singleton_device::instance()}
{

}

QString qml_node_base::node() const
{
  return m_node;
}

QObject*qml_node_base::device() const
{
  return m_device;
}

QString qml_node_base::path() const
{
  return m_path;
}

QVariantMap qml_node_base::extended() const
{
  QVariantMap map;

  if(m_ossia_node)
  {
    ossia::net::extended_attributes& xt = *m_ossia_node;
    // First remove all the existing keys
    for(const auto& pair : xt)
    {
      map.insert(QString::fromStdString(pair.first), anyToVariant(pair.second));
    }
  }

  return map;
}

void qml_node_base::setNode(QString node)
{
  if (m_node == node)
    return;

  m_node = node;
  resetNode();
  emit nodeChanged(node);
}

void qml_node_base::setDevice(QObject* device)
{
  if (m_device == device)
    return;

  m_device = qobject_cast<qml_device*>(device);
  resetNode();
  emit deviceChanged(device);
}

void qml_node_base::setExtended(QVariantMap extended)
{
  auto current = this->extended();

  if (current == extended)
    return;

  if(m_ossia_node)
  {
    ossia::net::extended_attributes& xt = *m_ossia_node;

    // First remove all the erased keys
    for(auto& key : current.keys())
    {
      if(!extended.contains(key))
        xt.erase(key.toStdString());
    }

    // Then insert the new ones
    for(auto& key : extended.keys())
    {
      xt[key.toStdString()] = anyToVariant(extended[key]);
    }
  }
  emit extendedChanged(extended);
}

ossia::net::node_base& qml_node_base::findClosestParent(
    QObject* obj,
    ossia::net::node_base& root)
{
  if(obj)
  {
    for(auto node : obj->children())
    {
      qml_node* casted = qobject_cast<qml_node*>(node);
      if(casted && casted->device() == device() && casted->ossiaNode())
        return *casted->ossiaNode();
    }

    if(auto par = obj->parent())
    {
      return findClosestParent(par, root);
    }
  }
  return root;
}

void qml_node_base::setPath(QString path)
{
  if (m_path == path)
    return;

  m_path = path;

  emit pathChanged(path);
}

QVariant qml_node_base::anyToVariant(const boost::any& any) const
{
  if(auto v = boost::any_cast<QVariant>(&any))
    return *v;
  else if(auto s = boost::any_cast<std::string>(&any))
    return QString::fromStdString(*s);
  else if(auto vec = boost::any_cast<std::vector<std::string>>(&any))
  {
    QStringList s;
    s.reserve(vec->size());
    for(auto& string : *vec)
      s.append(QString::fromStdString(string));
    return s;
  }
  else if(auto i = boost::any_cast<int>(&any))
    return *i;
  else if(auto f = boost::any_cast<float>(&any))
    return *f;
  else if(auto d = boost::any_cast<double>(&any))
    return *d;
  else if(auto b = boost::any_cast<bool>(&any))
    return *b;
  return {};

}

}
}